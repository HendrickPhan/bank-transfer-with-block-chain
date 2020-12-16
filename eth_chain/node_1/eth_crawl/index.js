const fs = require('fs');
const Web3 = require('web3');
const net = require('net');
const express = require('express')
const axios = require('axios')

var coinbase;
var web3; 

const config = {
  "php-url": "http://bc-nginx",
  // "php-url": "http://127.0.0.1:5010",
}

const getCoinbase = (callBack) => {
  web3.eth.getCoinbase((err, _coinbase) => {
    coinbase = _coinbase;
    if (callBack) {
      callBack()
    }
  })
}

const getHighestBlock = async () => {
  let res = await axios.get(config['php-url'] + '/api/system/block-chain/block/highest');
  console.log(res)
  data = await res.data
  return data
}

const sendBlock = async (block) => {
  let res = await axios.post(config['php-url'] + '/api/system/block-chain/block', block);
  data = await res.data
  console.log("inserted block")
  return data
}

const sendTransaction = async (transaction) => {
  let res = await axios.post(config['php-url'] + '/api/system/block-chain/transaction', transaction);
  data = await res.data
  console.log("inserted transaction")
  return data
}

const connectWeb3 = (callBack) => {
  web3 = new Web3('../bc_node/data/geth.ipc', net); 
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

const main = async () => {
  connectWeb3(async () => {
    // getCoinbase();
    console.log(1);
    let highestBlock = await getHighestBlock();
    let lastBlockNumber = highestBlock ? highestBlock.number : 0;
    console.log(lastBlockNumber)
    while (true) {
      let blockNumber;
      await web3.eth.getBlockNumber(function(error, result){ 
        blockNumber = result;
      });
      if(blockNumber !== lastBlockNumber) {
        let block;
        await web3.eth.getBlock(lastBlockNumber, function(e, r) { 
          block = r;
        });
        await sendBlock(block) 

        // lastBlock = blockNumber;
        lastBlockNumber += 1;
        if(block.transactions.length > 0) {
          block.transactions.map(async function (v) {
            let transaction;
            await web3.eth.getTransaction(v, function(e, r) { 
              transaction = r; 
            });
            await sendTransaction(transaction);
          })
        }
      } else {
        continue;
      }
    }
    
  });
}


main()