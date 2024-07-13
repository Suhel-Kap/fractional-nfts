// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {FractionalNFT} from "../src/FractionalNFT.sol";
import {LicenseNFT} from "../src/LicenseNFT.sol";
import {MyUSDC} from "../src/MyUSDC.sol";

contract NftScript is Script {
    uint256 public constant FRACTIONS = 10;
    uint256 public constant LICENSE_PRICE = 500; // needs to be multiplied by usdc.decimals()
    uint256 public constant FRACTION_PRICE = 50; // needs to be multiplied by usdc.decimals()
    uint256 public constant PLATFORM_FEE = 200000;
    uint256 public constant TOTAL_LICENSE_NFT = 500;
    uint256 public constant TOTAL_FRACTION_NFT = 5000;

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        MyUSDC usdc = new MyUSDC();
        LicenseNFT licenseNft = new LicenseNFT(
            usdc,
            FRACTIONS,
            LICENSE_PRICE * 10 ** usdc.decimals(),
            TOTAL_LICENSE_NFT
        );
        FractionalNFT fractionalNft = new FractionalNFT(
            usdc,
            licenseNft,
            PLATFORM_FEE,
            FRACTION_PRICE * 10 ** usdc.decimals(),
            TOTAL_FRACTION_NFT
        );
        licenseNft.setFractionalNft(fractionalNft);
        vm.stopBroadcast();
    }
}
