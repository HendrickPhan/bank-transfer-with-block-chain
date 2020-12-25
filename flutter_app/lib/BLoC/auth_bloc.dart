import 'package:app/Networking/api_responses.dart';
import 'package:app/Networking/api_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app/Models/auth_model.dart';
import 'dart:async';
import 'bloc.dart';

class AuthBloc implements Bloc {
  ApiProvider _provider = ApiProvider();
  final _storage = FlutterSecureStorage();

  String _token;
  StreamController _authController;

  StreamSink<ApiResponse<AuthModel>> get authSink => _authController.sink;
  Stream<ApiResponse<AuthModel>> get authStream => _authController.stream;

  AuthBloc() {
    _authController = StreamController<ApiResponse<AuthModel>>();
  }

  Future<String> callApiLogin({String phoneNumber, String password}) async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone_number'] = phoneNumber;
    data['password'] = password;
    final response = await _provider.post(
      url: 'login',
      data: data,
    );
    //save response token to secure storage_loginController
    await _storage.write(key: "token", value: response);
    return response;
  }

  login({String phoneNumber, String password}) async {
    authSink.add(ApiResponse.loading('Đang đăng nhập'));
    try {
      _token = await callApiLogin(phoneNumber: phoneNumber, password: password);
      authSink
          .add(ApiResponse.completed(AuthModel(loggedIn: true, token: _token)));
    } catch (e) {
      authSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  checkLoggedIn() async {
    _token = await _storage.read(key: "token");
    if (_token == null) {
      authSink
          .add(ApiResponse.completed(AuthModel(loggedIn: false, token: null)));
    } else {
      // todo: call api to check if token is valid
      authSink
          .add(ApiResponse.completed(AuthModel(loggedIn: true, token: _token)));
    }
  }

  logout() async {
    print("ok");
    await _storage.delete(key: 'token');
    authSink
        .add(ApiResponse.completed(AuthModel(loggedIn: false, token: null)));
  }

  @override
  void dispose() {
    _authController.close();
  }
}
