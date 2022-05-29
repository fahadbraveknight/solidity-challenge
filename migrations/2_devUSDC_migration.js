const devUSDCMigrations = artifacts.require("devUSDC");

module.exports = function (deployer) {
  deployer.deploy(devUSDCMigrations);
};
