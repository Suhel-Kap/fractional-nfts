"use client";

import { WalletButton } from "@/components/WalletButton";
import {
  balanceOfFractionalNft,
  mintFractionalNft,
} from "@/lib/contractUtils/fractionalNft";
import { allowanceOfUsdc, approveUsdc } from "@/lib/contractUtils/usdc";
import { useModal } from "connectkit";
import { useEffect, useState } from "react";
import { formatUnits } from "viem";
import { useAccount, useWalletClient } from "wagmi";

export default function Home() {
  const [quantity, setQuantity] = useState(1);
  const [nftBalance, setNftBalance] = useState("0");
  const { data: signer } = useWalletClient();
  const { isConnected, address } = useAccount();
  const { open, setOpen } = useModal();

  const handleBuy = async () => {
    if (!isConnected) {
      setOpen(!open);
      return;
    }
    if (address && signer) {
      const allowance = await allowanceOfUsdc(address);
      console.log(allowance);
      if (allowance === BigInt(0)) {
        const { status } = await approveUsdc(signer);
        if (status === "success") {
          console.log("Approved");
        }
      }
      const mintRes = await mintFractionalNft(signer, quantity.toString());
      console.log(mintRes);
      if (mintRes.status === "success") {
        fetchBalance();
      }
    }
  };

  const fetchBalance = async () => {
    if (address) {
      const balance = await balanceOfFractionalNft(address);
      const balanceFormatted = formatUnits(balance, 0);
      setNftBalance(balanceFormatted);
    }
  };
  useEffect(() => {
    fetchBalance();
  }, []);

  return (
    <main className="flex min-h-screen flex-col items-center justify-between p-24">
      <h1 className="text-5xl font-semibold text-center">
        Buy 1/10th Fractionalised NFTs
      </h1>
      <div className="flex flex-col items-center">
        <div className="flex items-center justify-center">
          <button
            onClick={() => setQuantity(quantity - 1)}
            className="px-4 py-2 bg-gray-200 text-gray-800"
          >
            -
          </button>
          <span className="px-4 py-2 bg-gray-200 text-gray-800">
            {quantity}
          </span>
          <button
            onClick={() => setQuantity(quantity + 1)}
            className="px-4 py-2 bg-gray-200 text-gray-800"
          >
            +
          </button>
        </div>
        <button
          onClick={handleBuy}
          className="mt-4 px-4 py-2 bg-gray-800 text-white"
        >
          Buy {quantity} NFTs
        </button>
        <p className="mt-4 text-center">Your NFT balance: {nftBalance} NFTs</p>
      </div>
      <WalletButton />
    </main>
  );
}
