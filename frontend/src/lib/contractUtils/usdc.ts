import { Address, WalletClient, maxUint256, parseUnits } from "viem";
import { config } from "../config";

const usdcContractConfig = {
  abi: config.USDC_ABI,
  address: config.USDC_ADDRESS as Address,
  chain: config.client.chain,
};

const approveUsdc = async (signer: WalletClient) => {
  const [address] = await signer.getAddresses();

  const txHash = await signer.writeContract({
    ...usdcContractConfig,
    account: address,
    functionName: "approve",
    args: [config.FRACTION_NFT_ADDRESS, maxUint256],
  });

  const res = await config.client.waitForTransactionReceipt({
    hash: txHash,
  });

  return {
    txHash,
    status: res.status,
  };
};

const mintUsdc = async (signer: WalletClient, amount = "10000") => {
  const [address] = await signer.getAddresses();

  const txHash = await signer.writeContract({
    ...usdcContractConfig,
    account: address,
    functionName: "mint",
    args: [address, parseUnits(amount, 6)],
  });

  const res = await config.client.waitForTransactionReceipt({
    hash: txHash,
  });

  return {
    txHash,
    status: res.status,
  };
};

const balanceOfUsdc = async (address: Address) => {
  const balance = await config.client.readContract({
    ...usdcContractConfig,
    account: address,
    functionName: "balanceOf",
    args: [address],
  });

  return balance as bigint;
};

const allowanceOfUsdc = async (address: Address) => {
  const allowance = await config.client.readContract({
    ...usdcContractConfig,
    account: address,
    functionName: "allowance",
    args: [address, config.FRACTION_NFT_ADDRESS],
  });

  return allowance as bigint;
};

export { approveUsdc, mintUsdc, balanceOfUsdc, allowanceOfUsdc };
