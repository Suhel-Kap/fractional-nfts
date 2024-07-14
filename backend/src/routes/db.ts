import express from "express";
import Batch from "../models/Batch";
import Fraction from "../models/Fraction";

const router = express.Router();

// Get all batches
router.get("/batches", async (req, res) => {
  try {
    const batches = await Batch.find().populate("fractions");
    res.json(batches);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
});

// Get incomplete batches
router.get("/batches/incomplete", async (req, res) => {
  try {
    const incompleteBatches = await Batch.find({ isComplete: false }).populate(
      "fractions",
    );
    res.json(incompleteBatches);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
});

// Get complete batches without a license NFT
router.get("/batches/complete-without-license", async (req, res) => {
  try {
    const batches = await Batch.find({
      isComplete: true,
      licenseNftTokenId: { $exists: false },
    }).populate("fractions");
    res.json(batches);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
});

// Get a specific batch by ID
router.get("/batches/:id", async (req, res) => {
  try {
    const batch = await Batch.findById(req.params.id).populate("fractions");
    if (!batch) {
      return res.status(404).json({ message: "Batch not found" });
    }
    res.json(batch);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
});

// Get all fractions
router.get("/fractions", async (req, res) => {
  try {
    const fractions = await Fraction.find();
    res.json(fractions);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
});

// Get fractions by user wallet address
router.get("/fractions/user/:walletAddress", async (req, res) => {
  try {
    const fractions = await Fraction.find({
      userWalletAddress: req.params.walletAddress,
    });
    res.json(fractions);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
});

// Get fractions count for a specific chain
router.get("/fractions/count/:chainId", async (req, res) => {
  try {
    const count = await Fraction.countDocuments({
      chainId: req.params.chainId,
    });
    res.json({ chainId: req.params.chainId, count });
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
});

export default router;
