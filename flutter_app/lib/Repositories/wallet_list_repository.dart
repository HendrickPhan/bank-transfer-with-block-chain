import 'dart:async';
import 'package:app/Networking/api_provider.dart';
import 'package:app/Models/wallet_list_model.dart';

class WalletListRepository {
  ApiProvider _provider = ApiProvider();

  Future<WalletListModel> fetchWalletListData({int page = 1}) async {
    final response =
        await _provider.get(url: "wallet/?page=" + page.toString());
    return WalletListModel.fromJson(response);
  }
}
