// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "hardhat/console.sol";

contract Mescat {
    struct SSSS {
        string eid; // event id
        string content;
        bool hasCid; // this record has associated CID; this must be true to use cid
        string cid;
    }

    uint private _recordSize = 0;

    mapping(string => SSSS) private _ssssRecords;

    function setSSSS(
        string memory eid,
        string memory content,
        bool hasCid,
        string memory cid
    ) public {
        _ssssRecords[eid] = SSSS(eid, content, hasCid, cid);
        _recordSize += 1;
    }

    function getSSSS(
        string memory eid
    )
        public
        view
        returns (
            string memory eventId,
            string memory content,
            bool hasCid,
            string memory cid
        )
    {
        console.log("Record size", _recordSize);
        return (
            _ssssRecords[eid].eid,
            _ssssRecords[eid].content,
            _ssssRecords[eid].hasCid,
            _ssssRecords[eid].cid
        );
    }
}

/*
DeployModules#MarketPlace - 0x5FbDB2315678afecb367f032d93F642f64180aa3
DeployModules#Mescat - 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512
DeployModules#MusiCat - 0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0
 */
