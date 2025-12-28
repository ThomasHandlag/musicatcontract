// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "hardhat/console.sol";

contract MusiCat is ERC721URIStorage {
    uint256 private _nextTokenId;

    mapping(uint256 => address) private _creators;

    event AssetMinted(
        uint256 tokenId,
        string tokenURI,
        address marketPlaceAddress
    );

    constructor() ERC721("MusiCat", "MSC") {}

    function _baseURI() internal pure override returns (string memory) {
        return "https://ipfs.io/ipfs/";
    }

    // Function to set the token URI for asset
    function mintAsset(
        string memory uri,
        address marketPlaceAddress
    ) public returns (uint256) {
        uint256 tokenId = _nextTokenId++;
        _mint(msg.sender, tokenId);
        _creators[tokenId] = msg.sender;
        _setTokenURI(tokenId, uri);
        setApprovalForAll(marketPlaceAddress, true);
        emit AssetMinted(tokenId, uri, marketPlaceAddress);
        return tokenId;
    }

    function count() public view returns (uint256) {
        return _nextTokenId;
    }

    function getAssetOwnedBySender(
        address sender
    ) public view returns (uint256[] memory) {
        uint256 ownedCount = balanceOf(sender);
        if (ownedCount <= 0) {
            return new uint256[](0);
        }
        uint256[] memory ownedAssets = new uint256[](ownedCount);
        uint256 index = 0;
        for (uint256 i = 0; i < _nextTokenId; i++) {
            if (index >= ownedCount) {
                break;
            }
            if (ownerOf(i) == sender) {
                ownedAssets[index++] = i;
            }
        }

        return ownedAssets;
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        return _creators[tokenId] != address(0);
    }

    function creatorOf(uint256 tokenId) external view returns (address) {
        require(_exists(tokenId), "Token does not exist");
        return _creators[tokenId];
    }

    function getTokenCreatedBySender(
        address sender
    ) external view returns (uint256[] memory) {
        uint256 createdCount = 0;
        for (uint256 i = 0; i < _nextTokenId; i++) {
            if (_creators[i] == sender) {
                createdCount++;
            }
        }

        uint256[] memory createdAssets = new uint256[](createdCount);
        uint256 index = 0;
        for (uint256 i = 0; i < _nextTokenId; i++) {
            if (_creators[i] == sender) {
                createdAssets[index++] = i;
            }
        }

        return createdAssets;
    }

    function burnAsset(uint256 tokenId) external {
        delete _creators[tokenId];
        _burn(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
