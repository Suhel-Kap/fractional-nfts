import async from "async";
import { processFractionMintEvent } from "../controllers/eventController";
import { ethers } from "ethers";

const eventQueue = async.queue(
  async (task: { to: string; tokenId: ethers.BigNumber }, callback) => {
    try {
      await processFractionMintEvent(task.to, task.tokenId);
      callback();
    } catch (error: any) {
      console.error(
        `Error processing event for token ${task.tokenId.toString()}:`,
        error,
      );
      callback(error);
    }
  },
  1,
);

eventQueue.error((err: any) => {
  console.error("Task experienced an error:", err);
});

export const queueEvent = (task: { to: string; tokenId: ethers.BigNumber }) => {
  eventQueue.push(task);
  console.log(`Event queued: Fraction NFT minted ${task.tokenId.toString()}`);
};
