import 'dart:async';
import 'package:app/Networking/api_provider.dart';
import 'package:app/Models/wallet_model.dart';
import 'package:app/setting.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WalletRepository {
  ApiProvider _provider = ApiProvider();
  final _storage = FlutterSecureStorage();

  Future<WalletModel> fetchWalletData({int walletId}) async {
    final response = await _provider.get(url: "wallet/" + walletId.toString());
    return WalletModel.fromJson(response);
  }

  Future<Null> addWallet() async {
    final nodeResponse = await _provider.get(
        url: "address/", customBase: environment["blockchainNodeUrl"]);

    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = nodeResponse["public"];
    //save private key to storage
    await _storage.write(
      key: nodeResponse["public"],
      value: nodeResponse["private"],
    );

    await _provider.post(
      url: 'wallet',
      data: data,
    );
  }
}
