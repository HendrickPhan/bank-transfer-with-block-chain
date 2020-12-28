import 'dart:async';
import 'package:app/Networking/api_provider.dart';
import 'package:app/Models/transaction_model.dart';
import 'package:app/Ultilities/log.dart';

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

  Future<TransactionModel> cashOut({TransactionModel transaction}) async {
    final response = await _provider.post(
      url: 'transaction/cash-out',
      data: transaction.toJson(),
    );
    Log.debug('cashOut ' + response.toString());
    return TransactionModel.fromJson(response);
  }
}
