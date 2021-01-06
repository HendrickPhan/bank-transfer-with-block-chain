import 'package:app/Screens/Transaction/pin_code_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/Widget/Transaction/bank_account_name_widget.dart';
import 'package:app/Models/transaction_model.dart';

class ConfirmTransferScreen extends StatefulWidget {
  static const String route = "confirm_transfer";
  final String fromAccount;
  final String toAccount;
  final int amount;
  final String description;

  const ConfirmTransferScreen({
    Key key,
    this.fromAccount,
    this.toAccount,
    this.amount,
    this.description,
  }) : super(key: key);

  @override
  _ConfirmTransferScreenState createState() => _ConfirmTransferScreenState();
}

class _ConfirmTransferScreenState extends State<ConfirmTransferScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  void onPressedSubmit() {
    TransactionModel transaction = TransactionModel(
      fromAccount: widget.fromAccount,
      toAccount: widget.toAccount,
      amount: widget.amount,
      description: widget.description,
    );
    Navigator.pushNamed(
      context,
      PinCodeScreen.route,
      arguments: transaction,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Builder(builder: (BuildContext context) {
            return ListView(
              children: [
                rowItem("From Account:", widget.fromAccount),
                rowItem("To Account:", widget.toAccount),
                BankAccountNameWidget(accountNumber: widget.toAccount),
                rowItem("Amount:", widget.amount.toString()),
                rowItem("Description:", widget.description),
                RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: new Text('Confirm'),
                  onPressed: onPressedSubmit,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Row rowItem(String fieldName, var value) {
    return Row(
      children: [
        Expanded(
          child: Text(fieldName, textAlign: TextAlign.left),
        ),
        Expanded(
          child: Text(value, textAlign: TextAlign.left),
        ),
      ],
    );
  }
}
