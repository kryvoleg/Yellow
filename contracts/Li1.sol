// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract RandomNameToken is ERC20 {
    string private _nameInternal;
    string private _symbolInternal;

    constructor(uint256 initialSupply) ERC20("Ret", "RT") {
        uint256 rand = uint256(
            keccak256(
                abi.encodePacked(
                    block.prevrandao,
                    block.timestamp,
                    msg.sender
                )
            )
        );

        bytes memory alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

        uint256 nameLen = 5 + (rand % 6);
        bytes memory nameBytes = new bytes(nameLen);

        for (uint256 i = 0; i < nameLen; i++) {
            uint256 idx = uint8(
                uint256(keccak256(abi.encodePacked(rand, i))) % alphabet.length
            );
            nameBytes[i] = alphabet[idx];
        }

        bytes memory symbolBytes = new bytes(3);
        for (uint256 j = 0; j < 3; j++) {
            uint256 idx2 = uint8(
                uint256(keccak256(abi.encodePacked(rand, j + 100))) %
                    alphabet.length
            );
            symbolBytes[j] = alphabet[idx2];
        }

        _nameInternal = string(nameBytes);
        _symbolInternal = string(symbolBytes);

        _mint(msg.sender, initialSupply * (10 ** uint256(decimals())));
    }

    function name() public view override returns (string memory) {
        return _nameInternal;
    }

    function symbol() public view override returns (string memory) {
        return _symbolInternal;
    }
}
