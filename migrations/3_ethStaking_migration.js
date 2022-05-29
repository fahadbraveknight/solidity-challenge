const EthStaking = artifacts.require("EthStaking");

module.exports = function (deployer) {
  const erc20Token = "ERC20_TOKEN";
  deployer.deploy(EthStaking, erc20Token);
};
