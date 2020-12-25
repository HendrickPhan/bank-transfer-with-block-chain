import 'package:app/Models/model.dart';

class DeviceModel implements Model {
  final int id;
  final int userId;
  final String token;

  DeviceModel({
    this.id,
    this.userId,
    this.token,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'],
      userId: json['user_id'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['token'] = this.token;
    return data;
  }
}
