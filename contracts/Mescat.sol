// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

contract Mescat {

    struct SSSS {
        string ssssKey;
        string userId;
    }

    mapping(string => SSSS) private _ssssRecords;

    function setSSSSRecord(string memory key, string memory ssssKey, string memory userId) external {
        _ssssRecords[key] = SSSS(ssssKey, userId);
    }

    function getSSSSRecord(string memory key) external view returns (string memory ssssKey, string memory userId) {
        SSSS storage record = _ssssRecords[key];
        return (record.ssssKey, record.userId);
    }
}