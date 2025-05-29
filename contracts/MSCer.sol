// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

contract MSCer {

    uint256 private _counter;
    
    struct MSCerInfo {
        string name;
        string bio;
        string website;
    }

    mapping(address => MSCerInfo) private _MSCers;
    
    event MSCerCreated(address indexed mscer, string name, string bio, string website);
    event MSCerInfoUpdated(address indexed mscer, string name, string bio, string website);
    event MSCerInfoDeleted(address indexed mscer);

    function createMSCer(string memory name, string memory bio, string memory website) external {
        _MSCers[msg.sender] = MSCerInfo(name, bio, website);
        emit MSCerCreated(msg.sender, name, bio, website);
    }

    function setBio(string memory bio, string memory website) external {
        _MSCers[msg.sender].bio = bio;
        _MSCers[msg.sender].website = website;
        emit MSCerInfoUpdated(msg.sender, _MSCers[msg.sender].name, bio, website);
    }

    function setWebsite(string memory website) external {
        _MSCers[msg.sender].website = website;
        emit MSCerInfoUpdated(msg.sender, _MSCers[msg.sender].name, _MSCers[msg.sender].bio, website);
    }
    
    function getMSCerInfo(address mscer) external view returns (string memory name, string memory bio, string memory website) {
        MSCerInfo storage mscerInfo = _MSCers[mscer];
        return (mscerInfo.name, mscerInfo.bio, mscerInfo.website);
    }
}