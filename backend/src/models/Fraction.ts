import mongoose, { Document, Schema } from "mongoose";

export interface IFraction extends Document {
  _id: mongoose.Types.ObjectId;
  fractionalNftAddress: string;
  fractionalNftTokenId: string;
  chainId: number;
  userWalletAddress: string;
  batchId?: mongoose.Types.ObjectId;
}

const FractionSchema: Schema = new Schema({
  fractionalNftAddress: { type: String, required: true },
  fractionalNftTokenId: { type: String, required: true },
  chainId: { type: Number, required: true },
  userWalletAddress: { type: String, required: true },
  batchId: { type: Schema.Types.ObjectId, ref: "Batch" },
});

export default mongoose.model<IFraction>("Fraction", FractionSchema);
