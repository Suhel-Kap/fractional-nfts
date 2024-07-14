import { balanceOfUsdc, mintUsdc } from "@/lib/contractUtils/usdc";
import { ConnectKitButton } from "connectkit";
import React, { useEffect, useState } from "react";
import { formatUnits } from "viem";
import { useAccount, useWalletClient } from "wagmi";

export const WalletButton = () => {
  const [usdcBalance, setUsdcBalance] = useState("0");

  const { data: signer } = useWalletClient();
  const { isConnected, address } = useAccount();

  useEffect(() => {
    const fetchBalance = async () => {
      if (address) {
        const balance = await balanceOfUsdc(address);
        const balanceFormatted = formatUnits(balance, 6);
        setUsdcBalance(balanceFormatted);
      }
    };

    fetchBalance();
  }, [address, isConnected]);

  const handleMintUsdc = async () => {
    if (signer) {
      await mintUsdc(signer);
    }
  };

  return (
    <div className="h-6">
      <ConnectKitButton />
      {isConnected && (
        <div className="flex my-3 py-3 space-x-2">
          <div className="text-sm text-gray-500 m-auto">{usdcBalance} USDC</div>
          <button
            className="px-4 py-2 border-2 rounded-md border-gray-400 text-gray-800"
            onClick={handleMintUsdc}
          >
            Mint USDC
          </button>
        </div>
      )}
    </div>
  );
};
