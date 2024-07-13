import mongoose, { Document, Schema } from "mongoose";
import { IFraction } from "./Fraction";

export interface IBatch extends Document {
  fractions: IFraction["_id"][];
  licenseNftAddress?: string;
  licenseNftTokenId?: string;
  chainId: number;
  isComplete: boolean;
}

const BatchSchema: Schema = new Schema({
  fractions: [{ type: Schema.Types.ObjectId, ref: "Fraction", required: true }],
  licenseNftAddress: { type: String },
  licenseNftTokenId: { type: String },
  chainId: { type: Number, required: true },
  isComplete: { type: Boolean, default: false },
});

export default mongoose.model<IBatch>("Batch", BatchSchema);
