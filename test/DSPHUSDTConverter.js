import { assert, expect } from "chai";
import { network, ethers, deployments } from "hardhat";

// eslint-disable-next-line node/no-missing-import
import { developmentChains, networkConfig } from "../helper-hardhat-config";

if (developmentChains.includes(network.name)) {
  describe("Testing Openergy and PrivateSale", async function () {
    let opgContract: any;
    let opgPrivateSaleContract: any;

    let opgContractFactory: any;
    let opgPrivateSaleContractFactory: any;

    let owner: any, addr1: any, addr2: any, addrs: any;

    before(async () => {
      [owner, addr1, addr2, ...addrs] = await ethers.getSigners();

      opgContractFactory = await ethers.getContractFactory("Openergy");
      opgContract = await opgContractFactory.connect(owner).deploy();

      opgPrivateSaleContractFactory = await ethers.getContractFactory(
        "OPGPrivateSale"
      );
      opgPrivateSaleContract = await opgPrivateSaleContractFactory
        .connect(owner)
        .deploy(opgContract.address);

      await opgContract.deployed();
      await opgPrivateSaleContract.deployed();

      await opgPrivateSaleContract.connect(owner).tokenPrivateSaleStart();
    });
  });
} else {
  // eslint-disable-next-line no-unused-expressions
  describe.skip;
}
