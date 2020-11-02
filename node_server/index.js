const fs = require('fs');
const Web3 = require('web3');
const net = require('net');
const read = require('read')
const express = require('express')
const BankAccountController = require('./controller/BankAccountController');
const BankBalanceController = require('./controller/BankBalanceController');
const TransactionController = require('./controller/TransactionController');

const app = express()
app.use(express.json());

const port = 3000;
var coinbase;
var web3; 

app.get('/', function (req, res) {
  res.send('Hello World')
})

// bank account routes
app.post('/new-address', function (req, res) {
  BankAccountController.newAddress(res, web3);
})

app.post('/bank-account', function (req, res) {
  BankAccountController.newBankAccount(req, res, web3, coinbase);
}) 

app.get('/bank-account', function (req, res) {
  BankAccountController.getBankAccountInfo(req, res, web3);
})

app.post('/bank-account/add-balance', function (req, res) {
  BankAccountController.addAccountBalance(req, res, web3, coinbase);
}) 

app.post('/send-ether', function (req, res) {
  BankAccountController.sendEther(req, res, web3, coinbase);
})

// bank balance routes
app.get('/bank-balance', function (req, res) {
  BankBalanceController.getBankBalance(req, res, web3);
})

app.post('/bank-balance', function (req, res) {
  BankBalanceController.addBankBalance(req, res, web3, coinbase);
})


app.get('/coin-base-balance', function (req, res) {
  web3.eth.getBalance(coinbase, function (error, result) {
    if (!error) {
      res.send(result);
    };
  });
}) 

// transaction routes
app.post('/transfer', function (req, res) {
  TransactionController.transfer(req, res, web3);
})

const getCoinbase = (callBack) => {
  web3.eth.getCoinbase((err, _coinbase) => {
    coinbase = _coinbase;
    if (callBack) {
      callBack()
    }
  })
}

const connectWeb3 = (callBack) => {
  web3 = new Web3('../eth_chain/data-2/geth.ipc', net); 
  web3.eth.net.isListening()
    .then(() => {
      console.log('Web3 connected');
      callBack();
    })
    .catch((e) => {
      console.log('Wow. Something went wrong: ' + e);
      process.exit();
    });
}

app.listen(port, ()=> {
  connectWeb3(() => {
    getCoinbase();
    console.log(`App running on port ${port}`);
  });
})