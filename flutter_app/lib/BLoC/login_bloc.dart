import 'package:app/Networking/api_responses.dart';
import 'package:app/Networking/api_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'dart:async';
import 'bloc.dart';

class LoginBloc implements Bloc {
  ApiProvider _provider = ApiProvider();
  final _storage = FlutterSecureStorage();

  String _token;
  StreamController _loginController;

  StreamSink<ApiResponse<String>> get loginSink => _loginController.sink;
  Stream<ApiResponse<String>> get loginStream => _loginController.stream;

  LoginBloc() {
    _loginController = StreamController<ApiResponse<String>>();
  }

  Future<String> callApiLogin({String phoneNumber, String password}) async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone_number'] = phoneNumber;
    data['password'] = password;
    final response = await _provider.post(
      url: 'login',
      data: data,
    );
    //save response token to secure storage
    await _storage.write(key: "token", value: response);
    return response;
  }

  login({String phoneNumber, String password}) async {
    loginSink.add(ApiResponse.loading('Đang đăng nhập'));
    try {
      _token = await callApiLogin(phoneNumber: phoneNumber, password: password);
      loginSink.add(ApiResponse.completed(_token));
    } catch (e) {
      loginSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  @override
  void dispose() {
    _loginController.close();
  }
}
