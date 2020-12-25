import 'dart:async';
import 'package:app/Networking/api_provider.dart';
import 'package:app/Models/user_model.dart';
import 'package:flutter/cupertino.dart';

class UserRepository {
  ApiProvider _provider = ApiProvider();

  Future<UserModel> fetchUserDetail() async {
    final response = await _provider.get(url: 'profile');
    debugPrint(response.toString());
    return UserModel.fromJson(response);
  }
}
