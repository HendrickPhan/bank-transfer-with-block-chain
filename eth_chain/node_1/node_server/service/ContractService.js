const fs = require('fs');

const getRawContract = () => {
  // read contract from file
  let contractFile = fs.readFileSync("./contract/BankTransfer.json");
  let contractRaw = JSON.parse(contractFile);
  return contractRaw;
}

const getDeployedContractAddress = () => {
  let deployedContractFile = fs.readFileSync("./contract/contract_deployed.json");
  let deployedContractRaw = JSON.parse(deployedContractFile);

  let deployedAddress = deployedContractRaw.options.address;
  return deployedAddress;
}

const getContract = (web3) => {
 // read contract from file
  let contractRaw = getRawContract();

 // get deployed contract info from file
  let deployedAddress = getDeployedContractAddress();

  let contract = new web3.eth.Contract(contractRaw.abi, deployedAddress);
  
  return contract;
}

exports.getRawContract = getRawContract;
exports.getDeployedContractAddress = getDeployedContractAddress;
exports.getContract = getContract;