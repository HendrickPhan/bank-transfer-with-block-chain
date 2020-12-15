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

class BankAccount {
  final String display;
  final String value;
  BankAccount({this.display, this.value});
}

class CreateTransaction extends StatelessWidget {
  CreateTransactionBloc _bloc;
  final BankAccountListModel<BankAccountModel> bankAccountList;
  CreateTransaction({Key key, this.bankAccountList});
  TextEditingController idUserReceiveController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  String _myActivity;
  String _myActivityResult;

  final formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    _myActivity = '';
    _myActivityResult = '';
  }

  Widget build(BuildContext context) {
    List data = [];
    data = [];
    // debugPrint(bankAccountList.total.toString());
    for (int i = 0; i < bankAccountList.total - 1; i++) {
      data.add({
        'display': bankAccountList.data[i].id.toString(),
        'value': bankAccountList.data[i].id.toString()
      });
    }
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/background.jpg'),
                    fit: BoxFit.cover),
                gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.white,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    tileMode: TileMode.clamp)),
            child:
                DraggableScrollableSheet(builder: (context, scrollController) {
              return Container(
                child: SingleChildScrollView(
                    controller: scrollController,
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
                                          _myActivity = value;
                                          debugPrint(_myActivity);
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
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400])),
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
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400])),
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
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                        ])),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(243, 245, 248, 1),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40))),
              );
            })));
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
