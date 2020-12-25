import 'package:app/Models/user_model.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Repositories/user_repository.dart';
import 'dart:async';
import 'bloc.dart';
import 'package:app/Ultilities/log.dart';

class UserBloc implements Bloc {
  UserRepository _userRepository;
  StreamController _userController;
  String token;

  StreamSink<ApiResponse<UserModel>> get userSink => _userController.sink;

  Stream<ApiResponse<UserModel>> get userStream => _userController.stream;

  UserBloc() {
    _userController = StreamController<ApiResponse<UserModel>>();
    _userRepository = UserRepository();
  }

  fetchUserDetail() async {
    userSink.add(ApiResponse.loading('Đang lấy dữ liệu người dùng'));
    try {
      UserModel userDetailStream = await _userRepository.fetchUserDetail();
      userSink.add(ApiResponse.completed(userDetailStream));
    } catch (e) {
      userSink.add(ApiResponse.error(e.toString()));
      Log.error(e.toString());
    }
  }

  @override
  void dispose() {
    _userController.close();
  }
}
