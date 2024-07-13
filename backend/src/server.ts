import express, { Express, Request, Response } from "express";
import mongoose from "mongoose";
import dotenv from "dotenv";
import { ethers } from "ethers";

dotenv.config();

const app: Express = express();
const PORT: string | number = process.env.PORT || 4000;
const RPC_URL: string = process.env.SEPOLIA_RPC_URL!;

// Middleware
app.use(express.json());

// Connect to MongoDB
mongoose
  .connect(process.env.MONGODB_URI as string)
  .then(() => console.log("Connected to MongoDB"))
  .catch((err) => console.error("Could not connect to MongoDB", err));

// Initialize Ethers provider
const provider = new ethers.providers.StaticJsonRpcProvider(RPC_URL);

// Define a simple route
app.get("/", (req: Request, res: Response) => {
  res.json({
    message: "Welcome to the Express MongoDB TypeScript server with Ethers.js!",
  });
});

// Example route using Ethers.js
app.get("/eth-block", async (req: Request, res: Response) => {
  try {
    const blockNumber = await provider.getBlockNumber();
    res.json({ currentBlock: blockNumber });
  } catch (error) {
    res.status(500).json({ error: "Failed to fetch Ethereum block number" });
  }
});

// Start the server
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
