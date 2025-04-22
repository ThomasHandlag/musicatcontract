// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "hardhat/console.sol";

contract MusiCat is ERC721, ERC721URIStorage {
    // Counter for the next token ID
    // This will be used to generate unique token IDs for each asset
    uint256 private _nextTokenId = 0;

    mapping(uint256 => string) private _tokenURIs;
    mapping(uint256 => address) private _owners;
    mapping(uint256 => string) private previewURIs;

    event AssetMinted(
        uint256 tokenId,
        string tokenURI,
        address marketPlaceAddress
    );

    constructor() ERC721("MusiCat", "MSC") {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://";
    }

    // Function to set the token URI for asset
    function mintAsset(
        string memory uri,
        string memory preview,
        address marketPlaceAddress
    ) public returns (uint256) {
        uint256 tokenId = _nextTokenId;
        _mint(msg.sender, tokenId);
        _tokenURIs[tokenId] = uri;
        _owners[tokenId] = msg.sender;
        previewURIs[tokenId] = preview;
        _nextTokenId++;
        setApprovalForAll(marketPlaceAddress, true);
        emit AssetMinted(tokenId, uri, marketPlaceAddress);
        return tokenId;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return _tokenURIs[tokenId];
    }

    function previewURI(uint256 tokenId) public view returns (string memory) {
        return previewURIs[tokenId];
    }

    function getAssetOwnedBySender(address sender) public view returns (uint256[] memory) {
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

    function getAssetById(uint256 tokenId) public view returns (string memory) {
        return _tokenURIs[tokenId];
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        return _owners[tokenId] != address(0);
    }

    function getMinterById(uint256 tokenId) public view returns (address) {
        return _owners[tokenId];
    }

    function getTokenCreatedBySender(address sender) external view returns (uint256[] memory) {
        uint256 createdCount = 0;
        for (uint256 i = 0; i < _nextTokenId; i++) {
            if (_owners[i] == sender) {
                createdCount++;
            }
        }

        uint256[] memory createdAssets = new uint256[](createdCount);
        uint256 index = 0;
        for (uint256 i = 0; i < _nextTokenId; i++) {
            if (_owners[i] == sender) {
                createdAssets[index++] = i;
            }
        }

        return createdAssets;
    }

    function burnAsset(uint256 tokenId) external {
        require(_owners[tokenId] == msg.sender, "Not the owner of the token");

        delete _tokenURIs[tokenId];
        delete _owners[tokenId];
        delete previewURIs[tokenId];

        _burn(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function getBalanceOf(address owner) external view returns (uint256) {
        return balanceOf(owner);
    }
}
