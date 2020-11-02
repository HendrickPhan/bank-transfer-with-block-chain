const net = require('net');
const Web3 = require('web3');

const connectWeb3 = (callBack) => {
  web3 = new Web3('../eth_chain/data-2/geth.ipc', net); 
  web3.eth.net.isListening()
    .then(() => callBack())
    .catch((e) => {
      console.log('Wow. Something went wrong: ' + e);
      process.exit();
    });       
}

const unlockCoinbase = () => {
  console.log("Unlocking coinbase account");
  try {
    // web3.eth.accounts.privateKeyToAccount('0x12f9e7d499b511e1a2d877ca1d7876e06ef4a82dfc30beb7cb9e18edaec3bd3a');
    // 
    console.log(web3.eth.coinbase)
  } catch(e) {
    console.log(e);
    return;
  }
}
const getBlockNo = () => {
  web3.eth.getBlockNumber()
  .then(console.log);
} 

const addAccount  = async () => {
  var account = web3.eth.accounts.privateKeyToAccount('0x348ce564d427a3311b6536bbcff9390d69395b06ed6c486954e971d960fe8709');
  await web3.eth.personal.unlockAccount(account.address, '');
  var accounts = await web3.eth.getAccounts(); 
  console.log(accounts);
}

const balance = async() => {
  web3.eth.getCoinbase((err, _coinbase) => {
    coinbase = _coinbase;
    web3.eth.getBalance("0x804f150991feb1150742cf2e414b164a4c5be605", (err, balance_) => {
      console.log(balance_);
  console.log(web3.utils.toWei("10", "ether"));

    })
  })
}

connectWeb3(balance);