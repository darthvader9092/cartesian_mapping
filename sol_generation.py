import json

with open("users.json", "r") as f:
    users = json.load(f)

user_entries = ""
for u in users:
    line = f'        users.push(User("{u["UserType"]}", {u["EnergyBalance"]}, {u["Price"]}, {u["Classification"]}, {u["Radian"]}, false, type(uint).max));\n'
    user_entries += line

sol_template = f"""
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SmartGridMapping {{
    address public owner;

    struct User {{
        string userType;
        int energyBalance;
        uint price;
        uint classification;
        uint radian;
        bool matched;
        uint matchedWith;
    }}

    User[] public users;

    constructor() {{
        owner = msg.sender;
{user_entries}    }}
}}
"""

with open("SmartGridMappingGenerated.sol", "w") as f:
    f.write(sol_template)

