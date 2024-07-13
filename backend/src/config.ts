import dotenv from "dotenv";
import fractionalNftAbi from "./abi/fractionalNft.abi.json";
import licenseNftAbi from "./abi/licenseNft.abi.json";

dotenv.config();

export const config = {
  PORT: process.env.PORT || 4000,
  MONGODB_URI: process.env.MONGODB_URI || "mongodb://localhost:27017/myapp",
  FRACTION_NFT_ADDRESS: process.env.FRACTION_NFT_ADDRESS!,
  LICENSE_NFT_ADDRESS: process.env.LICENSE_NFT_ADDRESS!,
  CHAIN_ID: process.env.CHAIN_ID || 11155111,
  PRIVATE_KEY: process.env.PRIVATE_KEY!,
  RPC_URL: process.env.RPC_URL,
  FRACTIONAL_NFT_ABI: fractionalNftAbi,
  LICENSE_NFT_ABI: licenseNftAbi,
};
