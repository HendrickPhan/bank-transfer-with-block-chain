import 'package:app/Networking/api_responses.dart';
import 'package:app/Networking/api_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'dart:async';
import 'bloc.dart';

class PinCodeBloc implements Bloc {
  ApiProvider _provider = ApiProvider();
  final _storage = FlutterSecureStorage();

  String _token;
  StreamController _pinCodeController;

  StreamSink<ApiResponse<String>> get pinCodeSink => _pinCodeController.sink;
  Stream<ApiResponse<String>> get pinCodeStream => _pinCodeController.stream;

  PinCodeBloc() {
    _pinCodeController = StreamController<ApiResponse<String>>();
  }

  Future<String> callApiActive({String pinCode}) async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pin_code'] = pinCode;
    final response = await _provider.put(
      url: 'auth/activate',
      data: data,
    );
    //save response token to secure storage
    await _storage.write(key: "token", value: response);
    return response;
  }

  activePinCode({String pinCode}) async {
    pinCodeSink.add(ApiResponse.loading('Activating'));
    try {
      _token = await callApiActive(pinCode: pinCode);
      pinCodeSink.add(ApiResponse.completed(_token));
    } catch (e) {
      pinCodeSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  @override
  void dispose() {
    _pinCodeController.close();
  }
}
