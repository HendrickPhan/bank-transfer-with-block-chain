const contractService = require('../service/ContractService');

exports.addBankBalance = async (req, res, web3, coinbase) => {
  var password = req.body.password;
  var amount = req.body.amount;

  // unlock owner account
  await web3.eth.personal.unlockAccount(coinbase, password, 1500)
  
  // Create Contract proxy class
  let contract = contractService.getContract(web3);
  
  // execute create account method
  contract.methods.addBankBalance(
    amount
  ).send(
    {from: coinbase}
  )
  .on('receipt', function(receipt){
    res.send(receipt);
  })
  .on('error', function(error, receipt) { // If the transaction was rejected by the network with a receipt, the second parameter will be the receipt.
    res.statusCode = 400;
    res.send({error, receipt});
  });
}

exports.getBankBalance = (req, res, web3) => {
  // Create Contract proxy class
  let contract = contractService.getContract(web3);
  
  contract.methods.bankBalance().call((error, balance) => {
    if(error) {
      res.statusCode = 400;
      res.send(error);
    } else {
      res.send({balance});
    }
  })
}
