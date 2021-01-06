import '../bloc.dart';
import 'dart:async';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Models/transaction_model.dart';
import 'package:app/Repositories/transaction_repository.dart';
import 'package:app/Ultilities/log.dart';

class CreateTransactionBloc implements Bloc {
  StreamController _controller;
  TransactionRepository _repository;

  StreamSink<ApiResponse<TransactionModel>> get transactionSink =>
      _controller.sink;
  Stream<ApiResponse<TransactionModel>> get transactionStream =>
      _controller.stream;

  CreateTransactionBloc() {
    _controller = StreamController<ApiResponse<TransactionModel>>();
    _repository = TransactionRepository();
  }

  transfer({TransactionModel transaction, String pinCode}) async {
    transactionSink.add(ApiResponse.loading('Transfering'));
    // try {
    TransactionModel responseTransaction = await _repository.transfer(
      transaction: transaction,
      pinCode: pinCode,
    );
    transactionSink.add(ApiResponse.completed(
      responseTransaction,
    ));
    // } catch (e) {
    // transactionSink.add(
    // ApiResponse.error(e.toString()),
    // );
    // }
  }

  cashOut({TransactionModel transaction}) async {
    transactionSink.add(ApiResponse.loading('Transfering'));
    try {
      TransactionModel responseTransaction = await _repository.cashOut(
        transaction: transaction,
      );
      transactionSink.add(ApiResponse.completed(
        responseTransaction,
      ));
    } catch (e) {
      transactionSink.add(
        ApiResponse.error(e.toString()),
      );
      Log.error('transfer ' + e.toString());
    }
  }

  @override
  void dispose() {
    _controller.close();
  }
}
