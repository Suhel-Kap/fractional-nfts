import { ethers } from "ethers";
import Fraction from "../models/Fraction";
import Batch, { IBatch } from "../models/Batch";
import { licenseContract } from "../services/contractService";
import { config } from "../config";

export async function processFractionMintEvent(
  to: string,
  tokenId: ethers.BigNumber,
) {
  console.log(`Processing Fraction NFT minted: ${tokenId.toString()}`);

  const fraction = new Fraction({
    fractionalNftAddress: config.FRACTION_NFT_ADDRESS,
    fractionalNftTokenId: tokenId.toString(),
    chainId: config.CHAIN_ID,
    userWalletAddress: to,
  });
  await fraction.save();

  const incompleteBatch = await Batch.findOne({
    isComplete: false,
    chainId: config.CHAIN_ID,
  });

  // If there is an incomplete batch, add the fraction to it
  // If the batch is now complete, mint the License NFT
  // Otherwise, create a new batch
  if (incompleteBatch) {
    incompleteBatch.fractions.push(fraction._id);
    console.log(`Fraction added to batch ${incompleteBatch._id}`);
    console.log(`Batch size: ${incompleteBatch.fractions.length}`);

    if (incompleteBatch.fractions.length === 10) {
      incompleteBatch.isComplete = true;
      await incompleteBatch.save();
      await mintLicenseNFT(incompleteBatch);
    } else {
      await incompleteBatch.save();
    }
  } else {
    const batch = new Batch({
      chainId: config.CHAIN_ID,
      fractions: [fraction._id],
    });
    await batch.save();
    console.log(`New batch created: ${batch._id}`);
  }
}

// Mint the License NFT for a batch
// This function is called when a batch is complete
// This creates an array of fraction IDs that is required to mint the License NFT
// This does not add anything to the database, the listener on the license contract will do that
async function mintLicenseNFT(batch: IBatch) {
  try {
    const fractionIds = await Promise.all(
      batch.fractions.map(async (fraction) => {
        const fractionNft = await Fraction.findById(fraction);
        return ethers.BigNumber.from(fractionNft?.fractionalNftTokenId);
      }),
    );
    const tx = await licenseContract.mint(fractionIds);
    await tx.wait();
    console.log(`License NFT minted for batch ${batch._id}`);
  } catch (error) {
    console.error("Failed to mint License NFT:", error);
  }
}
