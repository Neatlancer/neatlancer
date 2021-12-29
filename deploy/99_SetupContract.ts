/* eslint-disable node/no-missing-import */
/* eslint-disable node/no-unpublished-import */
import { deployments } from "hardhat";
import { DeployFunction } from "hardhat-deploy/dist/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";

const SetupContract: DeployFunction = async (
  hre: HardhatRuntimeEnvironment
) => {
  const { deploy } = deployments;
  const { deployer } = await hre.getNamedAccounts();

  await deploy("ProposalManager", {
    from: deployer,
    log: true,
  });
};

export default SetupContract;
SetupContract.tags = ["local"];
