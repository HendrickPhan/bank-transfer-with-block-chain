const contractService = require('../service/ContractService');

exports.transfer = async (req, res, web3) => {
  var private = req.body.private;
  var code = req.body.code;
  var fromAccount = req.body.from_account;
  var toAccount = req.body.to_account;
  var amount = req.body.amount;
  var fee = req.body.fee;
  var timeStamp = req.body.time_stamp;
  
  // add account to wallet
  var account = await web3.eth.accounts.wallet.add(private);
  
  // Create Contract proxy class
  let contract = contractService.getContract(web3);
  console.log(account.address);
  // execute create account method
  contract.methods.transfer(
    code, 
    fromAccount, 
    toAccount,
    fee, 
    amount,
    timeStamp,
  ).send({
    from: account.address,
    gas: 1000000,
    gasPrice: 2
  })
  .on('receipt', function(receipt){
    res.send(receipt);
  })
  .on('error', function(error, receipt) { // If the transaction was rejected by the network with a receipt, the second parameter will be the receipt.
    res.statusCode = 400;
    res.send({error, receipt});
  });
}

exports.getTransactionInfo = (req, res, web3) => {
  var code = req.query.code;
  
  // Create Contract proxy class
  let contract = contractService.getContract(web3);
  
  contract.methods.transactions(code).call((error, transaction) => {
    if(error) {
      res.statusCode = 400;
      res.send(error);
    } else {
      res.send(transaction);
    }
  })
}