import 'package:app/Models/model.dart';

class AuthModel implements Model {
  final String token;
  final bool loggedIn;

  AuthModel({this.token, this.loggedIn});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['loggedIn'] = this.loggedIn;
    return data;
  }
}
