const contractService = require('../service/ContractService');
const setting = require('../settings');
exports.newAddress = (res, web3) => {
  res.send(
    web3.eth.accounts.create()
  );
}

exports.newBankAccount = async (req, res, web3, coinbase) => {
  var password = setting.settings.password;
  var accountNumber = req.body.account_number;
  var ownerPhoneNumber = req.body.owner_phone_number;
  var accountAddress = req.body.account_address;

  // unlock owner account
  await web3.eth.personal.unlockAccount(coinbase, password, 1500)
  
  // Create Contract proxy class
  let contract = contractService.getContract(web3);
  
  // execute create account method
  contract.methods.createAccount(
    accountNumber, 
    ownerPhoneNumber, 
    accountAddress
  ).send({
    from: coinbase,
    gas: 1000000,
    gasPrice: 10
  })
  .on('receipt', function(receipt){ 
    sendEther(req, res, web3, coinbase)
  })
  .on('error', function(error, receipt) { // If the transaction was rejected by the network with a receipt, the second parameter will be the receipt.
    res.statusCode = 400;
    res.send({error, receipt});
  });

}

exports.getBankAccountInfo = (req, res, web3) => {
  var accountNumber = req.query.account_number;
  
  // Create Contract proxy class
  let contract = contractService.getContract(web3);
  
  contract.methods.bankAccounts(accountNumber).call((error, bankAccount) => {
    if(error) {
      res.statusCode = 400;
      res.send(error);
    } else {
      res.send(bankAccount);
    }
  })
}

exports.addAccountBalance = async (req, res, web3, coinbase) => {
  var accountNumber = req.body.account_number;
  var password = setting.settings.password;
  var code = req.body.code;
  var amount = req.body.amount;
  var timeStamp = req.body.time_stamp;
  // unlock owner account
  await web3.eth.personal.unlockAccount(coinbase, password, 1500)
  console.log(coinbase);
  // Create Contract proxy class
  let contract = contractService.getContract(web3);
  // execute create account method
  contract.methods.addAccountBalance(
    code,
    accountNumber, 
    amount, 
    timeStamp
  ).send(
    {
      from: coinbase,
      gas: 1000000,
      gasPrice: 10
    }
  )
  .on('receipt', function(receipt){
    res.send(receipt);
  })
  .on('error', function(error, receipt) { // If the transaction was rejected by the network with a receipt, the second parameter will be the receipt.
    res.statusCode = 400;
    res.send({error, receipt});
  });

}

const sendEther = async (req, res, web3, coinbase) => {
  var accountAddress = req.body.account_address;
  var password = setting.settings.password;
  await web3.eth.personal.unlockAccount(coinbase, password, 1500)
  web3.eth.sendTransaction({
    from: coinbase, 
    to: accountAddress, 
    value: web3.utils.toWei("1", "ether"),
    gas: 1000000,
    gasPrice: 10
  })
  .on('receipt', function(receipt){
    res.send(receipt);
  })
  .on('error', function(error, receipt) { // If the transaction was rejected by the network with a receipt, the second parameter will be the receipt.
    res.status(400)
      .send({error, receipt});
  });
}
exports.sendEther = sendEther;