import 'dart:async';
import 'package:app/Models/bank_account_model.dart';
import 'package:app/Models/paginate_model.dart';
import 'package:app/Networking/api_provider.dart';
import 'package:flutter/cupertino.dart';

class BankAccountRepository {
  ApiProvider _provider = ApiProvider();

  Future<PaginateModel<BankAccountModel>> fetchBankAccountListData(
      {int page = 1}) async {
    final response =
        await _provider.get(url: "bank-account?page=" + page.toString());
    return PaginateModel<BankAccountModel>.fromJson(
        (json) => new BankAccountModel.fromJson(json), response);
  }

  Future<BankAccountModel> fetchBankAccountDetail({int id}) async {
    final response = await _provider.get(url: "bank-account/" + id.toString());
    debugPrint(response.toString());
    return BankAccountModel.fromJson(response);
  }
}
