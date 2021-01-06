import 'package:app/Models/model.dart';

class TransactionModel implements Model {
  final int id;
  final int type;
  final String typeText;
  final String code;
  final String fromAccount;
  final String toAccount;
  final String description;
  final int amount;
  final int fee;
  final int status;
  final String statusText;
  final String createdAt;
  final String updatedAt;

  TransactionModel({
    this.id,
    this.type,
    this.typeText,
    this.code,
    this.fromAccount,
    this.toAccount,
    this.amount,
    this.description,
    this.fee,
    this.status,
    this.statusText,
    this.createdAt,
    this.updatedAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    print(json.toString());
    return TransactionModel(
      id: int.tryParse(json['id'].toString()),
      type: int.tryParse(json['type'].toString()),
      typeText: json['typeText'],
      code: json['code'],
      fromAccount: json['from_account'],
      toAccount: json['to_account'],
      amount: int.tryParse(json['amount'].toString()),
      description: json['description'],
      fee: int.tryParse(json['fee'].toString()),
      // status: json['status'],
      statusText: json['statusText'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['code'] = this.code;
    data['from_account'] = this.fromAccount;
    data['to_account'] = this.toAccount;
    data['amount'] = this.amount;
    data['description'] = this.description;
    data['fee'] = this.fee;
    data['status'] = this.status;
    return data;
  }
}
