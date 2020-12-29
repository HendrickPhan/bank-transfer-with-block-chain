import 'dart:async';
import 'package:app/Networking/api_provider.dart';
import 'package:app/Models/transaction_model.dart';
import 'package:app/Ultilities/log.dart';
import 'package:app/Models/paginate_model.dart';
import 'package:flutter/cupertino.dart';

class TransactionRepository {
  ApiProvider _provider = ApiProvider();

  Future<TransactionModel> transfer({TransactionModel transaction}) async {
    final response = await _provider.post(
      url: 'transaction/transfer',
      data: transaction.toJson(),
    );
    Log.debug('transfer ' + response.toString());
    return TransactionModel.fromJson(response);
  }

  // Future<TransactionModel> cashOut({TransactionModel transaction}) async {
  //   final response = await _provider.post(
  //     url: 'transaction/cash-out',
  //     data: transaction.toJson(),
  //   );
  //   Log.debug('cashOut ' + response.toString());
  //   return TransactionModel.fromJson(response);
  // }
  Future<PaginateModel<TransactionModel>> fetchTransactionListData(
      {int page = 1}) async {
    final response =
        await _provider.get(url: "bank-account?page=" + page.toString());
    return PaginateModel<TransactionModel>.fromJson(
        (json) => new TransactionModel.fromJson(json), response);
  }

  Future<PaginateModel<TransactionModel>> getAllTransactions(
      {int page = 1}) async {
    final response =
        await _provider.get(url: "transaction?page=" + page.toString());
    return PaginateModel<TransactionModel>.fromJson(
        (json) => new TransactionModel.fromJson(json), response);
  }

  Future<PaginateModel<TransactionModel>> getAllTransactionsById(
      {String bankAccountID}) async {
    debugPrint('zzzz');
    debugPrint(bankAccountID);
    final response =
        await _provider.get(url: "transaction/" + bankAccountID.toString());
    return PaginateModel<TransactionModel>.fromJson(
        (json) => new TransactionModel.fromJson(json), response);
  }

  Future<TransactionModel> fetchTransactionData({int id}) async {
    final response = await _provider.get(url: "transaction/" + id.toString());
    return TransactionModel.fromJson(response);
  }
}
