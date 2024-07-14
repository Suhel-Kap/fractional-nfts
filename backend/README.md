# Fractional NFT Backend

## Getting Started

First, install the dependencies:

```bash
yarn install
```

Then, copy the `.env.example` file to `.env`:

```bash
cp .env.example .env
```

You can now run the development server:

```bash
yarn dev
```

The server will start on [http://localhost:4000](http://localhost:4000).

Make sure you have a MongoDB instance running on your local machine on the default port `27017`.

## How does it work?

There are 2 event listeners that manage the batching and minting of License NFTs.

1. Fractional NFT Event Listener:
  This event listener listens to the `FractionalNFTMinted` event emitted by the Fractional NFT contract. It then creates an entry in the `fractions` collection in the database.
  It then looks up at a batch from the `batch` collection that does not have 10 fraction NFTs and adds the fraction NFT to the batch. If the batch is full, it will mint the License NFT.

2. License NFT Event Listener:
  This event listener listens to the `Transfer` event emitted by the License NFT contract. It then updates the `batch` collection with the License NFT ID.


We have created an async queue to manage the incoming `FractionalNFTMinted` events. This is to ensure that the events are processed in the order they are received and there is no race condition in the minting of License NFTs.

## API Endpoints

1. `/database/batches` - Get all the batches in the database.
2. `/database/batches/incomplete` - Get all the incomplete batches in the database.
3. `/database/batches/complete-without-license` - Get all the complete batches without a License NFT.
4. `/database/batches/:id` - Get a batch by ID.
5. `/database/fractions` - Get all the fractions in the database.
6. `/database/fractions/user/:walletAddress` - Get all the fractions of a user.
7. `/database/fractions/:id` - Get a fraction by ID.
8. `/database/fractions/count/:chainId` - Get the total number of fractions minted on a chain.
