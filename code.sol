// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SmartGridMapping {
    address public owner;

    struct User {
        string userType; // "producer", "consumer", or "prosumer"
        int energyBalance; // positive for producers, negative for consumers
        uint price; // selling price for producers/prosumers or max buying price for consumers
        uint classification; // scale from 1 to 5
        uint radian; // position in circular grid (radians)
        bool matched;
        uint matchedWith; // index of the user this user is matched with
    }

    User[] public users;

    event UserAdded(uint indexed userId, string userType);
    event MappingDone(uint indexed producerId, uint indexed consumerId, uint energyTransferred);
    event MappingDetails(string message);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;

        // Producers (classification 1-5, radians 0 to 360 in scaled format)
        users.push(User("producer", 70, 12, 2, 53, false, type(uint).max));
        users.push(User("producer", 122, 12, 4, 142, false, type(uint).max));
        users.push(User("producer", 88, 8, 3, 120, false, type(uint).max));
        users.push(User("producer", 67, 10, 2, 70, false, type(uint).max));
        users.push(User("producer", 53, 12, 1, 180, false, type(uint).max));
        users.push(User("producer", 138, 11, 5, 20, false, type(uint).max));
        users.push(User("producer", 109, 13, 4, 300, false, type(uint).max));
        users.push(User("producer", 63, 8, 2, 200, false, type(uint).max));
        users.push(User("producer", 58, 8, 1, 270, false, type(uint).max));
        users.push(User("producer", 139, 10, 5, 240, false, type(uint).max));

        // Consumers
        users.push(User("consumer", -94, 11, 3, 290, false, type(uint).max));
        users.push(User("consumer", -114, 8, 4, 260, false, type(uint).max));
        users.push(User("consumer", -138, 7, 5, 102, false, type(uint).max));
        users.push(User("consumer", -120, 10, 4, 110, false, type(uint).max));
        users.push(User("consumer", -58, 10, 1, 95, false, type(uint).max));
        users.push(User("consumer", -137, 10, 5, 160, false, type(uint).max));
        users.push(User("consumer", -50, 11, 1, 15, false, type(uint).max));
        users.push(User("consumer", -57, 7, 1, 210, false, type(uint).max));
        users.push(User("consumer", -137, 11, 5, 185, false, type(uint).max));
        users.push(User("consumer", -112, 13, 4, 230, false, type(uint).max));

        // Prosumers
        users.push(User("prosumer", 50, 9, 2, 60, false, type(uint).max));
        users.push(User("prosumer", -45, 9, 3, 62, false, type(uint).max));
    }

    function distance(User memory a, User memory b) internal pure returns (uint) {
        int dx = int(a.classification) - int(b.classification);
        int dy = int(a.radian) - int(b.radian);
        int dz = int(a.price) - int(b.price);
        return uint(dx * dx + dy * dy + dz * dz);
    }

    function commitMapping() public onlyOwner {
        for (uint i = 0; i < users.length; i++) {
            if ((keccak256(abi.encodePacked(users[i].userType)) == keccak256("consumer") || 
                keccak256(abi.encodePacked(users[i].userType)) == keccak256("prosumer")) && users[i].energyBalance < 0 && !users[i].matched) {
                uint closestId = type(uint).max;
                uint minDistance = type(uint).max;

                for (uint j = 0; j < users.length; j++) {
                    if ((keccak256(abi.encodePacked(users[j].userType)) == keccak256("producer") ||
                        keccak256(abi.encodePacked(users[j].userType)) == keccak256("prosumer")) && 
                        users[j].energyBalance > 0 && !users[j].matched) {

                        uint dist = distance(users[i], users[j]);
                        if (dist < minDistance) {
                            minDistance = dist;
                            closestId = j;
                        }
                    }
                }

                if (closestId != type(uint).max) {
                    int transferAmount = min(-users[i].energyBalance, users[closestId].energyBalance);
                    users[i].energyBalance += transferAmount;
                    users[closestId].energyBalance -= transferAmount;

                    if (users[i].energyBalance == 0) users[i].matched = true;
                    if (users[closestId].energyBalance == 0) users[closestId].matched = true;

                    users[i].matchedWith = closestId;
                    users[closestId].matchedWith = i;

                    emit MappingDone(closestId, i, uint(transferAmount));
                    emit MappingDetails(string(abi.encodePacked("Mapped: ", users[closestId].userType, " #", toString(closestId), " => ", users[i].userType, " #", toString(i))));
                }
            }
        }
    }

    function min(int a, int b) internal pure returns (int) {
        return a < b ? a : b;
    }

    function getUsers() public view returns (User[] memory) {
        return users;
    }

    function toString(uint value) internal pure returns (string memory) {
        if (value == 0) return "0";
        uint temp = value;
        uint digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
}
