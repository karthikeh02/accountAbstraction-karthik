// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {MinimalAccount} from "../src/ethereum/MinimalAccount.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployMinimal is Script {
    function run() public {
        // Call deployMinimalAccount here so it actually runs when the script is executed
        (HelperConfig helperConfig, MinimalAccount minimalAccount) = deployMinimalAccount();

        // Print the deployed contract address to ensure the deployment succeeded
        console.log("MinimalAccount deployed at:", address(minimalAccount));
    }

    function deployMinimalAccount() public returns (HelperConfig, MinimalAccount) {
        HelperConfig helperConfig = new HelperConfig();
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();
        console.log("Deploying...");

        vm.startBroadcast(config.account);

        MinimalAccount minimalAccount = new MinimalAccount(config.entryPoint);
        minimalAccount.transferOwnership(config.account);

        vm.stopBroadcast();

        return (helperConfig, minimalAccount);
    }
}
