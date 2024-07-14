import { Address, WalletClient, maxUint256, parseUnits } from "viem";
import { config } from "../config";

const fractionalNftContractConfig = {
  abi: config.FRACTIONAL_NFT_ABI,
  address: config.FRACTION_NFT_ADDRESS as Address,
  chain: config.client.chain,
};

const mintFractionalNft = async (signer: WalletClient, amount = "1") => {
  const [address] = await signer.getAddresses();

  const txHash = await signer.writeContract({
    ...fractionalNftContractConfig,
    account: address,
    functionName: "mint",
    args: [address, BigInt(amount)],
  });

  const res = await config.client.waitForTransactionReceipt({
    hash: txHash,
  });

  return {
    txHash,
    status: res.status,
  };
};

const balanceOfFractionalNft = async (address: Address) => {
  const balance = await config.client.readContract({
    ...fractionalNftContractConfig,
    account: address,
    functionName: "balanceOf",
    args: [address],
  });

  return balance as bigint;
};

export { mintFractionalNft, balanceOfFractionalNft };
