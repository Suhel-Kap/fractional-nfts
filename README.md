# Fractional NFTs

## Introduction

Purchasing an NFT is a big investment. It is not always possible for everyone to buy an NFT. Fractional NFTs are a way to own a part of an NFT. This project is a simple implementation of fractional NFTs.

## Deployed Contracts

| Contract | Address |
| --- | --- |
| [MyUSDC](https://sepolia.etherscan.io/address/0x6495288e577D0B8Ba57BE470283Cf7a0dacd2bBc) | 0x6495288e577D0B8Ba57BE470283Cf7a0dacd2bBc |
| [FractionalNFT](https://sepolia.etherscan.io/address/0x6A519b7275C31920Ab5000be86cc4e36B77308D0) | 0x6A519b7275C31920Ab5000be86cc4e36B77308D0 |
| [LicenseNFT](https://sepolia.etherscan.io/address/0xbE4aEAaf0853C2f018937aa577d05bD035130Ee3) | 0xbE4aEAaf0853C2f018937aa577d05bD035130Ee3 |

## Getting Started

### Contracts setup

First, you need to deploy the smart contract. You can deploy the smart contract on the Sepolia test network using the following command:

```bash
cd contracts
```

Fill up the `.env` by following the `.env.example` file. Then run the following command:

```bash
make deploy
```

You can take a look at the `README.md` file in the `contracts` directory for more information.

### Backend setup

```bash
cd backend
```

First, install the dependencies:

```bash
npm install
```

Copy the `.env.example` file to `.env`:

```bash
cp .env.example .env
```

You can now run the development server:

```bash
npm run dev
```

You can read the `README.md` file in the `backend` directory for more information.

This will setup the backend server and will start listening to the contract events.

### Frontend setup

```bash
cd frontend
```

First, install the dependencies:

```bash
npm install
```

Then, copy the `.env.example` file to `.env.local`:

```bash
cp .env.example .env.local
```

You can now run the development server:

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

This will setup the frontend server and you can start interacting with the contracts.

Since this is a test environment, you can find a USDC faucet at the bottom of the page. You can use this faucet to get some USDC to interact with the contracts. Make sure you have some Sepolia ETH in your wallet to pay for the gas fees.
