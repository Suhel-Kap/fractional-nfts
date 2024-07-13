// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LicenseNFT is ERC721, Ownable {
    uint256 private _nextTokenId;

    // @dev - This mapping is used to check if a fraction NFT has been used to mint a license NFT
    mapping(uint256 => bool) public usedFractionNFTs;

    constructor() ERC721("LicenseNFT", "LIC") Ownable(msg.sender) {}

    function mint(address to) external onlyOwner returns (uint256) {
        uint256 tokenId = _nextTokenId++;
        _mint(to, tokenId);
        return tokenId;
    }

    function getNextTokenId() external view returns (uint256) {
        return _nextTokenId;
    }
}
