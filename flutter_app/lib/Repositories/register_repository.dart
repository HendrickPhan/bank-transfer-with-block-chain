import 'dart:async';
import 'package:app/Networking/api_provider.dart';
import 'package:app/Models/user_model.dart';

class RegisterRepository {
  ApiProvider _provider = ApiProvider();

  Future<String> register(UserModel userModel) async {
    final response = await _provider.post(
      url: 'register/',
      data: userModel.toJson(),
    );
    //save response token to secure storage
    return response;
  }
}
