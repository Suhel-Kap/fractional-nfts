// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {MyUSDC} from "./MyUSDC.sol";
import {LicenseNFT} from "./LicenseNFT.sol";

// Used NFT in LicenseNFT

contract FractionalNFT is ERC721, Ownable {
    uint256 private _nextTokenId;
    uint256 private fractions;
    MyUSDC public usdc;
    LicenseNFT public licenseNFT;
    uint256 public immutable i_platformFee;
    uint256 public price;

    // @dev - This mapping is used to keep track of how many fraction NFTs have been assigned to a license NFT
    mapping(uint256 => uint256) public mainLicenseFractionCount;

    // @dev - This mapping is used to keep track of which fraction NFTs have been assigned to a license NFT
    mapping(uint256 => uint256) public fractionNftToLicenseNft;

    event FractionNFTMinted(
        address indexed to,
        uint256 indexed tokenId,
        uint256 indexed licenseNftId
    );
    event FractionBurned(address indexed from, uint256 indexed tokenId);

    constructor(
        MyUSDC _usdc,
        LicenseNFT _licenseNFT,
        uint256 _platformFee,
        uint256 _price
    ) ERC721("FractionalNFT", "FRACT") Ownable(msg.sender) {
        usdc = _usdc;
        licenseNFT = _licenseNFT;
        i_platformFee = _platformFee;
        price = _price;
        usdc.approve(address(this), type(uint256).max);
    }

    /**
     * @notice - This will first transfer USDC worth price + fee, then mint a fraction NFT
     * when a fraction NFT is minted, it will increment the fraction count for the license NFT
     * if the fraction count is equal to the total fractions, it will increment the license NFT ID
     *
     * @dev - Mint a fraction NFT
     * @param to - Address to mint the NFT to
     * @param quantity - Number of NFTs to mint
     */
    function mint(address to, uint256 quantity) external {
        require(to != address(0), "Invalid address");
        require(quantity > 0, "Quantity must be greater than 0");
        require(
            usdc.balanceOf(msg.sender) >= (price + i_platformFee) * quantity,
            "Insufficient balance"
        );

        bool success = usdc.transferFrom(
            msg.sender,
            address(this),
            (price + i_platformFee) * quantity
        );
        require(success, "Transfer failed");

        uint256 licenseNftId = licenseNFT.getNextTokenId();
        for (uint256 i = 0; i < quantity; i++) {
            uint256 tokenId = _nextTokenId++;
            uint256 fractionCountForLicense = mainLicenseFractionCount[
                licenseNftId
            ];

            if (fractionCountForLicense == fractions) {
                licenseNftId++;
                mainLicenseFractionCount[licenseNftId] = 1;
            } else {
                mainLicenseFractionCount[licenseNftId]++;
            }

            fractionNftToLicenseNft[tokenId] = licenseNftId;

            _mint(to, tokenId);
            emit FractionNFTMinted(to, tokenId, licenseNftId);
        }
    }

    /**
     * @notice - This will burn a fraction NFT
     * when a fraction NFT is burned, it will decrement the fraction count for the license NFT
     * if the fraction count is equal to 0, it will decrement the license NFT ID
     *
     * @dev - Burn a fraction NFT
     * @param tokenId - ID of the NFT to burn
     */
    function burn(uint256 tokenId) external onlyOwner {
        require(exists(tokenId), "Token does not exist");

        uint256 licenseNftId = fractionNftToLicenseNft[tokenId];
        mainLicenseFractionCount[licenseNftId]--;

        _burn(tokenId);
        emit FractionBurned(msg.sender, tokenId);
    }

    // Only owner functions

    function setPrice(uint256 _price) external onlyOwner {
        price = _price;
    }

    function setFractions(uint256 _fractions) external onlyOwner {
        fractions = _fractions;
    }

    function withdrawPlatformFee(uint256 amount) external onlyOwner {
        require(
            amount <= usdc.balanceOf(address(this)),
            "Insufficient balance"
        );
        usdc.transfer(owner(), amount);
    }

    // View functions

    function getNextTokenId() external view returns (uint256) {
        return _nextTokenId;
    }

    function getFractionCountForLicense(
        uint256 licenseNftId
    ) external view returns (uint256) {
        return mainLicenseFractionCount[licenseNftId];
    }

    function getLicenseNftIdForFraction(
        uint256 tokenId
    ) external view returns (uint256) {
        return fractionNftToLicenseNft[tokenId];
    }

    function getPlatformFee() external view returns (uint256) {
        return i_platformFee;
    }

    function getPrice() external view returns (uint256) {
        return price;
    }

    function getFractionCount() external view returns (uint256) {
        return fractions;
    }

    function getLicenseNFT() external view returns (LicenseNFT) {
        return licenseNFT;
    }

    function getUSDC() external view returns (MyUSDC) {
        return usdc;
    }

    function getOwner() external view returns (address) {
        return owner();
    }

    function getBalance() external view returns (uint256) {
        return usdc.balanceOf(address(this));
    }

    function exists(uint256 tokenId) public view returns (bool) {
        return tokenId < _nextTokenId;
    }
}
