// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/console.sol";
import { LibString } from "solady/src/utils/LibString.sol";

interface ImmutableCreate2Factory {
    function hasBeenDeployed(
        address deploymentAddress
    ) external view returns (bool);

    function findCreate2Address(
        bytes32 salt,
        bytes calldata initializationCode
    ) external view returns (address deploymentAddress);

    function safeCreate2(
        bytes32 salt,
        bytes calldata initializationCode
    ) external payable returns (address deploymentAddress);
}

abstract contract Deployer {
    ImmutableCreate2Factory private constant IMMUTABLE_CREATE2_FACTORY =
        ImmutableCreate2Factory(0x0000000000FFe8B47B3e2130213B802212439497);

    bytes32 private constant DEFAULT_SALT = bytes32(uint256(0x1));

    function deploy(
        string memory name,
        bytes memory initCode
    ) internal returns (address) {
        return deploy(name, DEFAULT_SALT, initCode);
    }

    function deploy(
        string memory name,
        bytes32 salt,
        bytes memory initCode
    ) internal returns (address) {
        bytes32 initCodeHash = keccak256(initCode);
        address deploymentAddress = address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            hex"ff",
                            address(IMMUTABLE_CREATE2_FACTORY),
                            salt,
                            initCodeHash
                        )
                    )
                )
            )
        );
        bool deploying;
        if (!IMMUTABLE_CREATE2_FACTORY.hasBeenDeployed(deploymentAddress)) {
            deploymentAddress = IMMUTABLE_CREATE2_FACTORY.safeCreate2(
                salt,
                initCode
            );
            deploying = true;
        }
        console.log(
            pad(deploying ? "Deploying" : "Found", 10),
            pad(name, 13),
            pad(LibString.toHexString(deploymentAddress), 43),
            LibString.toHexString(uint256(initCodeHash))
        );
        return deploymentAddress;
    }

    function pad(
        string memory name,
        uint256 n
    ) internal pure returns (string memory) {
        string memory padded = name;
        while (bytes(padded).length < n) {
            padded = string.concat(padded, " ");
        }
        return padded;
    }
}
