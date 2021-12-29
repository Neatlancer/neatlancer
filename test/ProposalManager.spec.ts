/* eslint-disable no-unused-expressions */
/* eslint-disable node/no-missing-import */
import chai from "chai";
import chaiAsPromised from "chai-as-promised";
import { getContract } from "../utils/getContract";
import hre from "hardhat";
import { ethers } from "ethers";

chai.use(chaiAsPromised);
const { expect } = chai;
describe("ProposalManager unit tests", async () => {
  let proposalManager: ethers.Contract;

  beforeEach(async () => {
    proposalManager = await getContract("ProposalManager", null);
  });

  it("Should create a proposal", async () => {
    const paymentSchedule = [
      {
        amount: ethers.utils.parseEther("1"),
        paymentDate: new Date().getTime(),
      },
    ];
    const { firstClient } = await hre.getNamedAccounts();
    await proposalManager.createProposal(
      new Date().getTime(),
      firstClient,
      "Neatlancer",
      "Project for blockchain",
      paymentSchedule
    );

    expect(await proposalManager.paymentsFor(0)).to.eq(1);
  });
});
