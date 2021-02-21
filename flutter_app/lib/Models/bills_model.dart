import 'package:app/Models/model.dart';

class BillsModel implements Model {
  final int id;
  final int user_id;
  final int type;
  final String transaction_code;
  final int amount;
  final String time;
  final String paid_at;
  final int status;
  final String type_text;

  BillsModel(
      {this.id,
      this.user_id,
      this.type,
      this.transaction_code,
      this.amount,
      this.time,
      this.paid_at,
      this.status,
      this.type_text});

  factory BillsModel.fromJson(Map<String, dynamic> json) {
    return BillsModel(
      id: json['id'],
      user_id: json['user_id'],
      transaction_code: json['transaction_code'],
      amount: json['amount'],
      time: json['time'],
      paid_at: json['paid_at'],
      status: json['status'],
      type_text: json['type_text'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.user_id;
    data['transaction_code'] = this.transaction_code;
    data['amount'] = this.amount;
    data['time'] = this.time;
    data['paid_at'] = this.paid_at;
    data['status'] = this.status;
    data['type_text'] = this.type_text;
    return data;
  }
}
