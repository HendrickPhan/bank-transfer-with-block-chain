import 'package:app/Models/transaction_model.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Models/paginate_model.dart';
import 'package:app/Repositories/transaction_repository.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import '../bloc.dart';

class TransactionDetailBloc implements Bloc {
  TransactionRepository _transactionRepository;
  StreamController _controller;

  StreamSink<ApiResponse<TransactionModel>> get transactionDetailSink =>
      _controller.sink;

  Stream<ApiResponse<TransactionModel>> get transactionDetailStream =>
      _controller.stream;

  TransactionDetailBloc() {
    _controller = StreamController<ApiResponse<TransactionModel>>();
    _transactionRepository = TransactionRepository();
  }

  fetchTransactionData(int a) async {
    transactionDetailSink
        .add(ApiResponse.loading('Đang lấy dữ liệu người dùng'));
    try {
      TransactionModel transactionDetail =
          await _transactionRepository.fetchTransactionData(id: a);
      transactionDetailSink.add(ApiResponse.completed(transactionDetail));
    } catch (e) {
      transactionDetailSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  @override
  void dispose() {
    _controller.close();
  }
}
