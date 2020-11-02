import 'package:app/Models/model.dart';

class WalletModel implements Model {
  final int id;
  final int userId;
  final String address;

  WalletModel({this.id, this.userId, this.address});

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'],
      userId: json['user_id'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['address'] = this.address;
    return data;
  }
}
