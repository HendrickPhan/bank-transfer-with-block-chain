import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Widget/Error/err_widget.dart';
import 'package:app/Widget/Loading/loading_widget.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:app/Models/bank_account_model.dart';
import 'package:app/Models/bank_account_list_model.dart';
import 'package:app/BLoC/Transaction/create_transaction_bloc.dart';
import 'package:app/BLoC/BankAccount/bank_account_list_transaction_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './../Drawer/drawer.dart';

class CreateTransactionScreen extends StatefulWidget {
  @override
  _CreateTransactionScreenState createState() =>
      _CreateTransactionScreenState();
}

var cardAspectRatio = 12.0 / 16.0;
var widgetAspectRatio = cardAspectRatio * 1.2;

class _CreateTransactionScreenState extends State<CreateTransactionScreen> {
  BankAccountListTransactionBloc _bloc;
  BankAccountListModel bankAccountList;

  @override
  void initState() {
    super.initState();
    _bloc = BankAccountListTransactionBloc();
    _bloc.fetchBankAccountListsForTransaction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        child: StreamBuilder<ApiResponse<BankAccountListModel>>(
          stream: _bloc.bankAccountListStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return LoadingWidget(loadingMessage: snapshot.data.message);
                  break;
                case Status.COMPLETED:
                  if (bankAccountList == null) {
                    bankAccountList = snapshot.data.data;
                  } else {
                    snapshot.data.data.data.forEach((element) {
                      bankAccountList.data.add(element);
                    });
                  }
                  return CreateTransaction(bankAccountList: bankAccountList);
                  break;
                case Status.ERROR:
                  return ErrWidget(
                    errorMessage: snapshot.data.message,
                    onRetryPressed: () =>
                        _bloc.fetchBankAccountListsForTransaction(),
                  );
                  break;
              }
            }
            return Container();
          },
        ),
      ),
    );
  }
}

class CreateTransaction extends StatefulWidget {
  final BankAccountListModel<BankAccountModel> bankAccountList;
  CreateTransaction({Key key, this.bankAccountList});

  @override
  _CreateTransactionState createState() => _CreateTransactionState();
}

class _CreateTransactionState extends State<CreateTransaction> {
  CreateTransactionBloc _bloc;
  TextEditingController idUserReceiveController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  String _myActivity;

  final formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    _myActivity = '';
    _bloc = CreateTransactionBloc();
  }

  Widget build(BuildContext context) {
    List data = [];
    data = [];
    for (int i = 0; i < widget.bankAccountList.total - 1; i++) {
      data.add({
        'display': widget.bankAccountList.data[i].id.toString(),
        'value': widget.bankAccountList.data[i].id.toString()
      });
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Create Transaction'),
        ),
        drawer: Container(width: 250, child: Drawer(child: DrawerNav())),
        body: StreamBuilder<ApiResponse<String>>(
            stream: _bloc.transactionStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data.status) {
                  case Status.LOADING:
                    return LoadingWidget(loadingMessage: snapshot.data.message);
                  case Status.COMPLETED:
                    Future.delayed(
                      Duration.zero,
                      () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateTransactionScreen()),
                        )
                      },
                    );
                    return Container();
                  case Status.ERROR:
                    Future.delayed(
                      Duration.zero,
                      () => showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: new Text("Error"),
                            content: new Text(
                                (snapshot.data.message.toString() ==
                                        '"Unauthorized"')
                                    ? "Sai username hoặc password"
                                    : snapshot.data.message),
                            actions: [
                              FlatButton(
                                onPressed: () => Navigator.pop(
                                    context, true), // passing true
                                child: Text('Ok'),
                              ),
                            ],
                          );
                        },
                      ).then(
                        (exit) {
                          if (exit == null) return;

                          if (exit) {
                            // user pressed Yes button
                          } else {
                            // user pressed No button
                          }
                        },
                      ),
                    );
                }
              }
              return SingleChildScrollView(
                  child: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 24,
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(16),
                                  child: DropDownFormField(
                                    titleText: 'Account',
                                    hintText: 'Please choose Account',
                                    value: _myActivity,
                                    onChanged: (value) {
                                      setState(() {
                                        _myActivity = value;
                                      });
                                    },
                                    dataSource: data,
                                    textField: 'display',
                                    valueField: 'value',
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15.0),
                                  child: TextFormField(
                                    controller: idUserReceiveController,
                                    decoration: InputDecoration(
                                        hintText: "Receive Account",
                                        fillColor: Colors.black,
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400])),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Invalid';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15.0, top: 20.0),
                                  child: TextFormField(
                                    controller: amountController,
                                    decoration: InputDecoration(
                                        hintText: "Amount",
                                        fillColor: Colors.black,
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400])),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Invalid';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 20.0),
                                  height: 50,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(colors: [
                                        Color.fromRGBO(143, 148, 251, 1),
                                        Color.fromRGBO(143, 148, 251, .6),
                                      ])),
                                  child: Center(
                                    child: FlatButton(
                                        onPressed: sendBtnClick,
                                        child: Text(
                                          "Send",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ]),
              ));
            }));
  }

  void sendBtnClick() {
    String idUser = _myActivity;
    String idUserReceive = idUserReceiveController.text;
    String amount = amountController.text;
    _bloc.createTransaction(
        accountNumber: idUser,
        toAccountNumber: idUserReceive,
        amount: int.parse(amount));
  }
}
