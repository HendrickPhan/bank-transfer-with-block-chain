var keythereum = require("keythereum");
keyObject = {"address":"8490fe60fb90f9142b177e8c793f979028a78639","crypto":{"cipher":"aes-128-ctr","ciphertext":"59717db99946c59bd0795ca88fb869e9b31243a54ac84be2015fdd5ae4436f98","cipherparams":{"iv":"7837d719df879802eb4dbf87dd3a3e37"},"kdf":"scrypt","kdfparams":{"dklen":32,"n":262144,"p":1,"r":8,"salt":"d49c74823d0ece9ce59539fda2bbd8b61cbe1c51bd380318ae8106d2250c5602"},"mac":"05dc391d21db0b5e6572f42f4cf88dec1d47b3fe8cc855a863aadb3a76bbd2b3"},"id":"6e7e5d7b-2e43-4470-bc30-89b5b2d5c246","version":3}
var read = require('read')
read({ prompt: 'Password: ', silent: true }, function(er, password) {
  if(er) {
    console.log("ERR: ", er);
    return;
  }
  try {
    var privateKey = keythereum.recover(password, keyObject);
  } catch (err) {
    console.log("ERR: ", err);
    return;
  }
  console.log("PUB: 0x8490fe60fb90f9142b177e8c793f979028a78639")
  console.log("PRIV: " + privateKey.toString('hex'));
})
