var Election = artifacts.require("./election.sol");

module.exports = function(deployer) {
  deployer.deploy(Election);
};