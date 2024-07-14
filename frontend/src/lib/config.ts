import { createPublicClient, http } from "viem";
import fractionalNftAbi from "./abi/fractionalNft.abi.json";
import usdcAbi from "./abi/myusdc.abi.json";
import { sepolia } from "viem/chains";

const client = createPublicClient({
  chain: sepolia,
  transport: http(process.env.NEXT_PUBLIC_RPC_URL),
});

export const config = {
  FRACTION_NFT_ADDRESS: process.env.NEXT_PUBLIC_FRACTION_NFT_ADDRESS!,
  USDC_ADDRESS: process.env.NEXT_PUBLIC_MY_USDC_ADDRESS!,
  RPC_URL: process.env.NEXT_PUBLIC_RPC_URL,
  FRACTIONAL_NFT_ABI: fractionalNftAbi,
  USDC_ABI: usdcAbi,
  client,
};
