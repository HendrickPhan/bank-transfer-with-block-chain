import 'dart:async';
import 'package:app/Networking/api_provider.dart';
import 'package:app/Models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserRepository {
  ApiProvider _provider = ApiProvider();
  final _storage = FlutterSecureStorage();

  Future<UserModel> login({String phoneNumber, String password}) async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone_number'] = phoneNumber;
    data['password'] = password;
    final response = await _provider.post(
      url: 'login',
      data: data,
    );
    //save response token to secure storage
    await _storage.write(key: "token", value: response);
    print(response);
    return UserModel.fromJson(response);
  }
}
