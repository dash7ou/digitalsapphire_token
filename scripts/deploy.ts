import { network, ethers } from "hardhat";
import fs from "fs";
import chalk from "chalk";
import R from "ramda";
import { utils } from "ethers";

import {
  networkConfig,
  developmentChains,
  testChains,
} from "../helper-hardhat-config";

import { verify, sleep } from "../helper-functions";

async function main() {
  console.log("\n\n 📡 Deploying...\n");

  const [deployer] = await ethers.getSigners();
  const openergy: any = await deploy("DigitalSapphire", [], {}, {}, deployer);

  // await deploy("OPGPrivateSale", [openergy.address], {}, {}, deployer);

  console.log(
    " 💾  Artifacts (address, abi, and args) saved to: ",
    chalk.blue("artifacts/"),
    "\n\n"
  );
}

const deploy = async (
  contractName: string,
  _args: any[] = [],
  overrides = {},
  libraries = {},
  deployer: any
) => {
  console.log(` 🛰  Deploying: ${contractName}`);

  const contractArgs = _args || [];
  const contractArtifacts = await ethers.getContractFactory(contractName, {
    libraries,
  });
  const deployed = await contractArtifacts
    .connect(deployer)
    .deploy(...contractArgs, overrides);
  const encoded = abiEncodeArgs(deployed, contractArgs);
  fs.writeFileSync(`artifacts/${contractName}.address`, deployed.address);

  console.log(
    " 📄",
    chalk.cyan(contractName),
    "deployed to:",
    chalk.magenta(deployed.address)
  );

  // Verify the deployment
  if (!developmentChains.includes(network.name)) {
    console.log(" 📄 Verifying contract...");
    await sleep(50000);
    await verify(deployed.address, contractArgs);
  }

  if (!encoded || encoded.length <= 2) return deployed;
  fs.writeFileSync(`artifacts/${contractName}.args`, encoded.slice(2));

  return deployed;
};

// ------ utils -------

// abi encodes contract arguments
// useful when you want to manually verify the contracts
// for example, on Etherscan
const abiEncodeArgs = (deployed: any, contractArgs: any) => {
  // not writing abi encoded args if this does not pass
  if (
    !contractArgs ||
    !deployed ||
    !R.hasPath(["interface", "deploy"], deployed)
  ) {
    return "";
  }
  const encoded = utils.defaultAbiCoder.encode(
    deployed.interface.deploy.inputs,
    contractArgs
  );
  return encoded;
};

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
