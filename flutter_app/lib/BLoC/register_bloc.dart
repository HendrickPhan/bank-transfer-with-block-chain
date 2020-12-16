import 'package:app/Networking/api_responses.dart';
import 'package:app/Models/user_model.dart';
import 'package:app/Repositories/register_repository.dart';

import 'dart:async';
import 'bloc.dart';

class RegisterBloc implements Bloc {
  RegisterRepository _registerRepository;
  StreamController _registerController;

  StreamSink<ApiResponse<String>> get registerSink => _registerController.sink;

  Stream<ApiResponse<String>> get registerStream => _registerController.stream;

  RegisterBloc() {
    _registerController = StreamController<ApiResponse<String>>();
    _registerRepository = RegisterRepository();
  }

  register(UserModel user) async {
    registerSink.add(ApiResponse.loading('Đang đăng ký'));
    try {
      String result = await _registerRepository.register(user);
      registerSink.add(ApiResponse.completed(result));
    } catch (e) {
      registerSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  @override
  void dispose() {
    _registerController.close();
  }
}
