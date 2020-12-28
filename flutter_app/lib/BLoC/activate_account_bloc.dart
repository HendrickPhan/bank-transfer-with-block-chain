import 'package:app/Networking/api_responses.dart';
import 'package:app/Networking/api_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'bloc.dart';
import 'package:app/Ultilities/log.dart';

class ActivateAccountBloc implements Bloc {
  ApiProvider _provider = ApiProvider();

  StreamController _controller;

  StreamSink<ApiResponse<bool>> get activateAccountSink => _controller.sink;
  Stream<ApiResponse<bool>> get activateAccountStream => _controller.stream;

  ActivateAccountBloc() {
    _controller = StreamController<ApiResponse<bool>>();
  }

  Future<String> callApiActivate({String pinCode}) async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pin_code'] = pinCode;
    final response = await _provider.put(
      url: 'auth/activate',
      data: data,
    );
    return response;
  }

  activate({String pinCode}) async {
    activateAccountSink.add(ApiResponse.loading('Activating'));
    try {
      String response = await callApiActivate(pinCode: pinCode);
      activateAccountSink.add(ApiResponse.completed(true));
    } catch (e) {
      activateAccountSink.add(ApiResponse.error(e.toString()));
      Log.error(e.toString());
    }
  }

  @override
  void dispose() {
    _controller.close();
  }
}
