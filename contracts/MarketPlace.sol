// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/interfaces/IERC721Enumerable.sol";

import "./MusiCat.sol";

contract MarketPlace is ReentrancyGuard, IERC721Receiver {
    constructor(address owner) {
        _feeAddress = payable(owner); // Set the deployer as the fee address
    }

    uint256 private _assetId;
    uint256 public _feePercent = 5; // marketplace fee each asset sold
    address private _feeAddress;

    struct Asset {
        uint256 id;
        address owner;
        address creator;
        address tokenAddress;
        uint256 tokenId;
        uint256 price;
        bool isForSale;
    }

    // Mapping from Asset ID to Asset struct
    // This mapping will store all the Assets listed for sale
    mapping(uint256 => Asset) private assets;

    function getAllAssets(
        address tokenAddress
    ) public view returns (Asset[] memory) {
        uint256 count = MusiCat(tokenAddress).getBalanceOf(address(this));
        Asset[] memory allAssets = new Asset[](count);
        uint256 index = 0;
        for (uint256 i = 1; i <= _assetId; i++) {
            if (assets[i].id != 0) {
                if (index < count) {
                    allAssets[index++] = assets[i];
                }
            }
        }
        return allAssets;
    }

    event AssetCreated(
        uint256 id,
        address indexed creator,
        address indexed owner,
        uint256 tokenId,
        uint256 price,
        bool isForSale
    );
    event AssetSold(
        uint256 id,
        address indexed seller,
        address indexed buyer,
        uint256 tokenId,
        uint256 price
    );
    event AssetPriceUpdated(uint256 id, address indexed seller, uint256 price);

    event AssetForSale(uint256 id, address indexed seller, bool isForSale);

    event AssetRemoved(uint256 id, address indexed seller);

    function createAsset(
        address tokenAddress,
        uint256 tokenId,
        uint256 price
    ) public payable nonReentrant {
        require(price >= 0, "Price must be greater than or equal to 0");
        uint256 id = ++_assetId;
        address creator = MusiCat(tokenAddress).getMinterById(tokenId);

        assets[id] = Asset(
            id,
            msg.sender,
            creator,
            tokenAddress,
            tokenId,
            price,
            false
        );
        // Transfer the token to the marketplace contract
        IERC721(tokenAddress).safeTransferFrom(
            msg.sender,
            address(this),
            tokenId
        );
        emit AssetCreated(_assetId, msg.sender, creator, tokenId, price, true);
    }

    function buyAsset(uint256 id) external payable nonReentrant {
        Asset storage asset = assets[id];
        require(asset.isForSale, "Asset is not for sale");
        require(msg.value >= asset.price, "Insufficient funds sent");

        uint256 fee = (asset.price * _feePercent) / 100;
        uint256 sellerAmount = asset.price - fee;

        // Transfer the fee to the fee address
        payable(_feeAddress).transfer(fee);
        // Transfer the remaining amount to the seller
        payable(asset.owner).transfer(sellerAmount);

        // Transfer the token to the buyer
        IERC721(asset.tokenAddress).safeTransferFrom(
            address(this),
            msg.sender,
            asset.tokenId
        );
        asset.isForSale = false;

        emit AssetSold(
            id,
            msg.sender,
            asset.tokenAddress,
            asset.tokenId,
            asset.price
        );

        delete assets[id]; // Remove the asset from the marketplace
    }

    function updateAssetPrice(
        uint256 id,
        uint256 newPrice
    ) external nonReentrant {
        Asset storage asset = assets[id];
        require(
            asset.owner == msg.sender,
            "Only the owner can update the price"
        );
        require(newPrice > 0, "Price must be greater than 0");
        asset.price = newPrice;
        emit AssetPriceUpdated(id, msg.sender, newPrice);
    }

    // Function to remove an Asset from the marketplace
    function removeAsset(
        uint256 id,
        address tokenAddress
    ) external nonReentrant {
        Asset storage asset = assets[id];
        require(
            asset.owner == msg.sender,
            "Only the owner can remove the Asset"
        );
        require(asset.tokenAddress == tokenAddress, "Token address mismatch");
        IERC721(asset.tokenAddress).safeTransferFrom(
            address(this),
            msg.sender,
            asset.tokenId
        );
        emit AssetRemoved(id, msg.sender);
    }

    function setForSale(uint256 id, bool isForSale) external nonReentrant {
        Asset storage asset = assets[id];
        require(
            asset.owner == msg.sender,
            "Only the owner can set the Asset for sale"
        );
        asset.isForSale = isForSale;
        emit AssetForSale(id, msg.sender, isForSale);
    }

    function getAsset(uint256 id) public view returns (Asset memory) {
        return assets[id];
    }

    function getAssetPrice(uint256 id) public view returns (uint256) {
        return assets[id].price;
    }

    function getMarketFee() public view returns (uint256) {
        return _feePercent;
    }

    function setMarketFee(uint256 fee) external {
        require(
            msg.sender == _feeAddress,
            "Only the fee address can set the fee"
        );
        require(fee <= 50, "Fee cannot exceed 50%");
        require(fee > 0, "Fee cannot be zero");
        _feePercent = fee;
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external override returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }
}
