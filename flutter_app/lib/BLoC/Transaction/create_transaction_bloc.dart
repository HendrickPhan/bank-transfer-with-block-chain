import 'package:app/Networking/api_responses.dart';
import 'package:app/Networking/api_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'dart:async';
import '../bloc.dart';

class CreateTransactionBloc implements Bloc {
  ApiProvider _provider = ApiProvider();
  final _storage = FlutterSecureStorage();

  String _token;
  StreamController _transactionController;

  StreamSink<ApiResponse<String>> get transactionSink =>
      _transactionController.sink;
  Stream<ApiResponse<String>> get transactionStream =>
      _transactionController.stream;

  CreateTransactionBloc() {
    _transactionController = StreamController<ApiResponse<String>>();
  }

  Future<String> callApiCreateTransaction(
      {String accountNumber, String toAccountNumber, int amount}) async {
    debugPrint('xxx');
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account_number'] = accountNumber;
    data['to_account_number'] = toAccountNumber;
    data['amount'] = amount;
    final response = await _provider.post(
      url: 'transaction',
      data: data,
    );
    //save response token to secure storage
    await _storage.write(key: "token", value: response);
    return response;
  }

  createTransaction(
      {String accountNumber, String toAccountNumber, int amount}) async {
    debugPrint('xxx');
    transactionSink.add(ApiResponse.loading('Đang thực hiện giao dịch'));
    try {
      debugPrint('123');
      _token = await callApiCreateTransaction(
          accountNumber: accountNumber,
          toAccountNumber: toAccountNumber,
          amount: amount);
      transactionSink.add(ApiResponse.completed(_token));
    } catch (e) {
      transactionSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  @override
  void dispose() {
    _transactionController.close();
  }
}
