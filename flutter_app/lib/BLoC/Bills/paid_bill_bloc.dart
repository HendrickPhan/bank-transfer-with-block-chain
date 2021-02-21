import '../bloc.dart';
import 'dart:async';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Ultilities/log.dart';
import 'package:app/Repositories/bills_repository.dart';

class PaidBillBloc implements Bloc {
  StreamController _controller;
  BillsRepository _repository;

  StreamSink<ApiResponse<String>> get billSink => _controller.sink;
  Stream<ApiResponse<String>> get billStream => _controller.stream;

  PaidBillBloc() {
    _controller = StreamController<ApiResponse<String>>();
    _repository = BillsRepository();
  }

  paid({int billId, String pinCode, String accountNumber}) async {
    billSink.add(ApiResponse.loading('Transfering'));
    try {
      String responseTransaction = await _repository.paid(
        billId: billId,
        pinCode: pinCode,
        accountNumber: accountNumber,
      );
      billSink.add(ApiResponse.completed(
        responseTransaction,
      ));
    } catch (e) {
      billSink.add(
        ApiResponse.error(e.toString()),
      );
    }
  }

  @override
  void dispose() {
    _controller.close();
  }
}
