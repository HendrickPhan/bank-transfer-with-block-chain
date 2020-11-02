import 'package:app/Models/model.dart';

class BankAccountModel extends Model {
  final int id;
  final int userId;
  final String accountNumber;
  final String type;
  final int amount;
  final String interestRate;
  final String status;
  final String dateDue;

  BankAccountModel(
      {this.id,
      this.userId,
      this.accountNumber,
      this.type,
      this.amount,
      this.interestRate,
      this.status,
      this.dateDue});

  factory BankAccountModel.fromJson(Map<String, dynamic> json) {
    return BankAccountModel(
      id: json['id'],
      userId: json['user_id'],
      accountNumber: json['account_number'],
      type: json['type_text'],
      amount: json['amount'],
      interestRate: json['interest_rate'],
      status: json['status_text'],
      dateDue: json['date_due'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['account_number'] = this.accountNumber;
    data['type'] = this.type;
    data['amount'] = this.amount;
    data['interest_rate'] = this.interestRate;
    data['status'] = this.status;
    data['date_due'] = this.dateDue;
    return data;
  }
}
