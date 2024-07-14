import express, { Express, Request, Response } from "express";
import mongoose from "mongoose";
import dotenv from "dotenv";
import { config } from "./config";
import { setupEventListeners } from "./services/contractService";
import dbRoutes from "./routes/db";

dotenv.config();

const app: Express = express();

// Middleware
app.use(express.json());

// Connect to MongoDB
mongoose
  .connect(process.env.MONGODB_URI as string)
  .then(() => {
    console.log("Connected to MongoDB");
    setupEventListeners();
  })
  .catch((err) => console.error("Could not connect to MongoDB", err));

// Setup routes
app.use("/database", dbRoutes);

// Start the server
app.listen(config.PORT, () => {
  console.log(`Server is running on port ${config.PORT}`);
});
