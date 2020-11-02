import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'dart:async';
import 'bloc.dart';

class CheckLoggedInBloc implements Bloc {
  StreamController _loggedInController;
  FlutterSecureStorage _storage;
  String _token;

  StreamSink<bool> get checkLoggedInSink => _loggedInController.sink;
  Stream<bool> get checkLoggedInStream => _loggedInController.stream;

  CheckLoggedInBloc() {
    _loggedInController = StreamController<bool>();
    _storage = FlutterSecureStorage();
  }

  Future<Null> getToken() async {
    _token = await _storage.read(key: "token");
  }

  checkLogged({String username, String password}) async {
    await getToken();
    if (_token == null) {
      checkLoggedInSink.add(false);
    } else {
      checkLoggedInSink.add(true);
    }
  }

  @override
  void dispose() {
    _loggedInController.close();
  }
}
