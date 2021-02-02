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
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
              Colors.white,
              Color(0xFF4E54C8),
            ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                tileMode: TileMode.clamp)),
        child: Padding(
          padding: EdgeInsets.only(top: 50),
          child: Container(
            child: Form(
              key: _formKey,
              child: Builder(builder: (BuildContext context) {
                return Column(
                  children: <Widget>[
                    Container(
                      height: 380,
                      margin: EdgeInsets.symmetric(horizontal: 32),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color.fromRGBO(35, 60, 103, 1),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 32,
                          ),
                          Text(
                            "Account From",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2.0),
                          ),
                          Text(
                            widget.fromAccount,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2.0),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Account To",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2.0),
                          ),
                          Text(
                            widget.toAccount,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2.0),
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          Text(
                            "AMOUNT",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue[100],
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2.0),
                          ),
                          Text(
                            widget.amount.toString(),
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[100],
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2.0),
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Description",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue[100],
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 2.0),
                                  ),
                                  Text(
                                    widget.description,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[100],
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 2.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    ButtonTheme(
                      minWidth: 200.0,
                      child: RaisedButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        child: new Text('Confirm'),
                        onPressed: onPressedSubmit,
                      ),
                    ),
                  ],
                );
                // return ListView(
                //   children: [
                //     rowItem(
                //       "From Account:",
                //       widget.fromAccount,
                //     ),
                //     rowItem("To Account:", widget.toAccount),
                //     BankAccountNameWidget(accountNumber: widget.toAccount),
                //     rowItem("Amount:", widget.amount.toString()),
                //     rowItem("Description:", widget.description),
                //     RaisedButton(
                //       color: Colors.blue,
                //       textColor: Colors.white,
                //       child: new Text('Confirm'),
                //       onPressed: onPressedSubmit,
                //     ),
                //   ],
                // );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Row rowItem(String fieldName, var value) {
    return Row(
      children: [
        Expanded(
          child: Text(fieldName,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
        Expanded(
          child: Text(value, textAlign: TextAlign.left),
        ),
      ],
    );
  }
}
