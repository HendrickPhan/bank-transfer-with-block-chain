const fs = require('fs');
const Web3 = require('web3');
const net = require('net');
const read = require('read')

var password;
var coinbase;
var web3; 

const handlePasswordFinishInput = (err, _password) => {
  password = _password;
  connectWeb3(() => {
    getCoinbase(deployContract);
  });
}

const getCoinbase = (callBack) => {
  web3.eth.getCoinbase((err, _coinbase) => {
    if(err) {
      console.log('Wow. Something went wrong: ' + e);
      process.exit();
    }
    coinbase = _coinbase;
    callBack()
  })
}

const connectWeb3 = (callBack) => {
  web3 = new Web3('../../../eth_chain/data-2/geth.ipc', net); 
  web3.eth.net.isListening()
    .then(() => callBack())
    .catch((e) => {
      console.log('Wow. Something went wrong: ' + e);
      process.exit();
    });
}

const deployContract = () => {
  let personal = web3.eth.personal;
  personal.unlockAccount(coinbase, password, 15000)
  
  let source = fs.readFileSync("../../contract/BankTransfer.json");
  let contracts = JSON.parse(source);

  // ABI description as JSON structure
  let abi = contracts.abi;

  // Smart contract EVM bytecode as hex
  let code = contracts.bytecode;

  // Create Contract proxy class
  let contract = new web3.eth.Contract(abi);

  contract.deploy({
    data: code,
    arguments: [1000000]
  })
  .send({
      from: coinbase,
      gas: 7000000,
      gasPrice: 1500
  })
  .then(function(newContractInstance){
    const content = JSON.stringify(newContractInstance, null, "\t");
    fs.writeFileSync('../../contract/contract_deployed.json', content);
    console.log('Finish');
    process.exit();
  });

}

read({ prompt: 'Password: ', silent: true}, handlePasswordFinishInput);


