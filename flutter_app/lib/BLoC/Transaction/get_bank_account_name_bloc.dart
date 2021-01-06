import '../bloc.dart';
import 'dart:async';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Networking/api_provider.dart';
import 'package:app/Models/transaction_model.dart';
import 'package:app/Repositories/transaction_repository.dart';
import 'package:app/Ultilities/log.dart';

class GetBankAccountNameBloc implements Bloc {
  StreamController _controller;
  ApiProvider _provider = ApiProvider();

  StreamSink<ApiResponse<String>> get sink => _controller.sink;
  Stream<ApiResponse<String>> get stream => _controller.stream;

  GetBankAccountNameBloc() {
    _controller = StreamController<ApiResponse<String>>();
  }

  Future<String> getBankAccountNameApi({String accountNumber}) async {
    final response = await _provider.get(
      url: 'bank-account/' + accountNumber + '/name',
    );
    return response;
  }

  getBankAccountName({String accountNumber}) async {
    sink.add(ApiResponse.loading('Loading'));
    try {
      String name = await getBankAccountNameApi(accountNumber: accountNumber);

      sink.add(ApiResponse.completed(
        name,
      ));
    } catch (e) {
      sink.add(
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
