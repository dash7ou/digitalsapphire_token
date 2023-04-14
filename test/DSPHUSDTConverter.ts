import { assert, expect } from "chai";
import { network, ethers, deployments } from "hardhat";

// eslint-disable-next-line node/no-missing-import
import { developmentChains, networkConfig } from "../helper-hardhat-config";

if (developmentChains.includes(network.name)) {
  describe("Testing DigitalSapphire Converter", async function () {
    let digitalSapphireContract: any;
    let dsphusdtConverterContract: any;
    let usdtContract: any;

    let digitalSapphireFactory: any;
    let dsphusdtConverterFactory: any;
    let usdtFactory: any;

    let owner: any, addr1: any, addr2: any, addrs: any;

    before(async () => {
      [owner, addr1, addr2, ...addrs] = await ethers.getSigners();

      digitalSapphireFactory = await ethers.getContractFactory(
        "DigitalSapphire"
      );
      digitalSapphireContract = await digitalSapphireFactory
        .connect(owner)
        .deploy();

      usdtFactory = await ethers.getContractFactory("TestCoin");
      usdtContract = await usdtFactory.connect(owner).deploy();

      dsphusdtConverterFactory = await ethers.getContractFactory(
        "DSPHUSDTConverter"
      );
      dsphusdtConverterContract = await dsphusdtConverterFactory
        .connect(owner)
        .deploy(digitalSapphireContract.address, usdtContract.address);

      await digitalSapphireContract.deployed();
      await dsphusdtConverterContract.deployed();
      await usdtContract.deployed();

      await dsphusdtConverterContract.connect(owner).tokenPrivateSaleStart();
    });

    describe("Test convert DSPH to USDT", () => {
      it("should convert successfully", async () => {
        // send converter usdt
        const usdtBalance = ethers.utils.parseEther("500");
        await usdtContract
          .connect(owner)
          .transfer(dsphusdtConverterContract.address, usdtBalance);

        // send another one some of tokens
        const dsphBalance = ethers.utils.parseEther("500");
        await digitalSapphireContract
          .connect(owner)
          .transfer(addr1.address, dsphBalance);

        // user give approve to converter contract
        await digitalSapphireContract
          .connect(addr1)
          .approve(dsphusdtConverterContract.address, dsphBalance);

        // convert
        await expect(
          dsphusdtConverterContract
            .connect(addr1)
            .convertDSPHToUSDT(dsphBalance)
        )
          .to.emit(dsphusdtConverterContract, "ConvertedDSPH")
          .withArgs(addr1.address, dsphBalance, dsphBalance.div(50));
      });
    });
  });
} else {
  // eslint-disable-next-line no-unused-expressions
  describe.skip;
}
