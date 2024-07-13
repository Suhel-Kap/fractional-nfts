// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {FractionalNFT} from "./FractionalNFT.sol";
import {MyUSDC} from "./MyUSDC.sol";

contract LicenseNFT is ERC721, Ownable {
    uint256 private _nextTokenId;
    FractionalNFT public fractionalNft;
    MyUSDC public usdc;
    uint256 public fractions;
    uint256 public price;

    // @dev - This mapping is used to check if a fraction NFT has been used to mint a license NFT
    mapping(uint256 => bool) public usedFractionNFTs;

    constructor(
        uint256 _fractions,
        uint256 _price
    ) ERC721("LicenseNFT", "LIC") Ownable(msg.sender) {
        fractions = _fractions;
        price = _price;
    }

    function setFractionalNft(FractionalNFT _fractionalNft) public onlyOwner {
        fractionalNft = _fractionalNft;
    }

    /**
     * @notice - This will mint a license NFT when 10 fractions are provided
     * @dev - Mint a license NFT
     * @param fractionalTokenIds - Array of 10 fraction NFT IDs
     */
    function mint(
        uint256[] memory fractionalTokenIds
    ) external onlyOwner returns (uint256) {
        require(
            fractionalTokenIds.length == fractions,
            "Must provide 10 fractions"
        );

        for (uint256 i = 0; i < fractions; i++) {
            require(
                fractionalNft.exists(fractionalTokenIds[i]),
                "Fraction does not exist"
            );
            require(
                usedFractionNFTs[fractionalTokenIds[i]] == false,
                "Fraction already used"
            );
        }

        bool success = usdc.transferFrom(
            address(fractionalNft),
            address(this),
            price
        );
        require(success, "Transfer failed");

        for (uint256 i = 0; i < fractions; i++) {
            usedFractionNFTs[fractionalTokenIds[i]] = true;
        }

        uint256 tokenId = _nextTokenId++;
        _mint(owner(), tokenId);
        return tokenId;
    }

    // Only owner functions

    function setUsdc(MyUSDC _usdc) external onlyOwner {
        usdc = _usdc;
    }

    function setPrice(uint256 _price) external onlyOwner {
        price = _price;
    }

    function setFractions(uint256 _fractions) external onlyOwner {
        fractions = _fractions;
    }

    function withdrawUsdc() external onlyOwner {
        usdc.transfer(owner(), usdc.balanceOf(address(this)));
    }

    // View functions

    function getNextTokenId() external view returns (uint256) {
        return _nextTokenId;
    }

    function getUsedFractionNFT(uint256 tokenId) external view returns (bool) {
        return usedFractionNFTs[tokenId];
    }

    function getUsdc() external view returns (MyUSDC) {
        return usdc;
    }

    function getFractions() external view returns (uint256) {
        return fractions;
    }

    function getPrice() external view returns (uint256) {
        return price;
    }

    function getOwner() external view returns (address) {
        return owner();
    }

    function getFractionalNft() external view returns (FractionalNFT) {
        return fractionalNft;
    }
}
