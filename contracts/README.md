## Foundry

To deploy the contract:

1. Copy the `.env.example` file to `.env` and fill in the values.
2. Run `make deploy` to deploy and verify the contract.

To run the tests:

1. Run `make test_contracts` to run the tests.


### Deployed Contract

| Contract | Address |
| --- | --- |
| [MyUSDC](https://sepolia.etherscan.io/address/0x6495288e577D0B8Ba57BE470283Cf7a0dacd2bBc) | 0x6495288e577D0B8Ba57BE470283Cf7a0dacd2bBc |
| [FractionalNFT](https://sepolia.etherscan.io/address/0x6A519b7275C31920Ab5000be86cc4e36B77308D0) | 0x6A519b7275C31920Ab5000be86cc4e36B77308D0 |
| [LicenseNFT](https://sepolia.etherscan.io/address/0xbE4aEAaf0853C2f018937aa577d05bD035130Ee3) | 0xbE4aEAaf0853C2f018937aa577d05bD035130Ee3 |

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
