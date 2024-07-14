import { ethers } from "ethers";
import { config } from "../config";
import { queueEvent } from "./eventQueue";
import Batch from "../models/Batch";

// Initialize providers and contracts
const provider = new ethers.providers.StaticJsonRpcProvider(config.RPC_URL);
const wallet = new ethers.Wallet(config.PRIVATE_KEY, provider);

export const fractionContract = new ethers.Contract(
  config.FRACTION_NFT_ADDRESS,
  config.FRACTIONAL_NFT_ABI,
  provider,
);

export const licenseContract = new ethers.Contract(
  config.LICENSE_NFT_ADDRESS,
  config.LICENSE_NFT_ABI,
  wallet,
);

// Setup event listeners
export function setupEventListeners() {
  fractionContract.on(
    "FractionNFTMinted",
    async (to: string, tokenId: ethers.BigNumber) => {
      // Queue event for processing - this listener is only responsible for queuing events
      queueEvent({ to, tokenId });
      console.log(`Event queued: Fraction NFT minted ${tokenId.toString()}`);
    },
  );

  // Find the latest batch that is not complete and assign the License NFT to it
  licenseContract.on("Transfer", async (from, to, tokenId) => {
    if (from === ethers.constants.AddressZero) {
      try {
        const latestBatch = await Batch.findOne({
          isComplete: true,
          licenseNftTokenId: { $exists: false },
        }).sort({ _id: -1 });
        if (latestBatch) {
          latestBatch.licenseNftAddress = config.LICENSE_NFT_ADDRESS;
          latestBatch.licenseNftTokenId = tokenId.toString();
          await latestBatch.save();
          console.log(
            `License NFT ${tokenId.toString()} assigned to batch ${latestBatch._id}`,
          );
        }
      } catch (error) {
        console.error("Error processing License NFT event:", error);
      }
    }
  });
}
