import 'package:app/Models/transaction_model.dart';
import 'package:app/Screens/Transaction/finish_transfer_screen.dart';
import 'package:flutter/material.dart';
// ----- screen
import 'package:app/Screens/Home/home_screen.dart';
// BankAccountListScreen
// ----- bloc
import 'package:app/BLoC/bloc_provider.dart';
import 'package:app/BLoC/Transaction/create_transaction_bloc.dart';
import 'package:app/Networking/api_responses.dart';

import 'package:app/Models/transaction_model.dart';
import 'package:app/Widget/Error/err_widget.dart';
import 'package:app/Widget/Loading/loading_widget.dart';

import 'package:flutter/gestures.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCodeScreen extends StatefulWidget {
  static const String route = "pin-code";
  final TransactionModel transactionModel;

  const PinCodeScreen({Key key, this.transactionModel}) : super(key: key);

  @override
  _PinCodeScreenState createState() => _PinCodeScreenState();
}

class _PinCodeScreenState extends State<PinCodeScreen> {
  var onTapRecognizer;
  CreateTransactionBloc _bloc;

  TextEditingController textEditingController = TextEditingController();

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    super.initState();
    _bloc = CreateTransactionBloc();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return render();
  }

  Widget render() {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      key: scaffoldKey,
      body: GestureDetector(
        onTap: () {},
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Pincode',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                    text: "Enter the code that use to encrypt your secret key",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 15,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 30),
                    child: PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 5,
                      obscureText: false,
                      obscuringCharacter: '*',
                      animationType: AnimationType.fade,
                      validator: (v) {
                        if (v.length < 5) {
                          return "*Please fill up all the cells properly";
                        } else {
                          return null;
                        }
                      },
                      pinTheme: PinTheme(
                        // shape: PinCodeFieldShape.circle,
                        // borderRadius: BorderRadius.circular(5),
                        fieldHeight: 60,
                        fieldWidth: 50,
                        activeFillColor:
                            hasError ? Colors.orange : Colors.white,
                        inactiveColor: Colors.black12,
                        inactiveFillColor: Colors.transparent,
                        selectedFillColor: Colors.white,
                      ),
                      cursorColor: Colors.black,
                      animationDuration: Duration(milliseconds: 300),
                      textStyle: TextStyle(fontSize: 20, height: 1.6),
                      backgroundColor: Colors.transparent,
                      enableActiveFill: true,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,

                      onCompleted: (v) {
                        print("Completed");
                      },
                      // onTap: () {
                      //   print("Pressed");
                      // },
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        print("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    )),
              ),
              SizedBox(
                height: 14,
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                child: ButtonTheme(
                  height: 50,
                  child: FlatButton(
                    onPressed: () {
                      formKey.currentState.validate();
                      // conditions for validating
                      if (currentText.length != 5) {
                        setState(() {
                          hasError = true;
                        });
                      } else {
                        setState(() {
                          hasError = false;
                          _bloc.transfer(
                            transaction: widget.transactionModel,
                            pinCode: currentText,
                          );
                          // _bloc.activate(pinCode: currentText);
                        });
                      }
                    },
                    child: Center(
                        child: Text(
                      "CONFIRM".toUpperCase(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.green.shade300,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.green.shade200,
                          offset: Offset(1, -2),
                          blurRadius: 5),
                      BoxShadow(
                          color: Colors.green.shade200,
                          offset: Offset(-1, 2),
                          blurRadius: 5)
                    ]),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Text("Clear"),
                    onPressed: () {
                      textEditingController.clear();
                    },
                  ),
                ],
              ),
              StreamBuilder<ApiResponse>(
                stream: _bloc.transactionStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data.status) {
                      case Status.LOADING:
                        return LoadingWidget(loadingMessage: "Loading");
                      // return LoadingWidget(loadingMessage: snapshot.data.message);
                      // break;
                      case Status.COMPLETED:
                        // transactionDetail = snapshot.data.data;
                        // return TransactionDetail(transactionDetail: transactionDetail);
                        Future.delayed(
                          Duration.zero,
                          () => {
                            Navigator.pushNamedAndRemoveUntil(
                                context,
                                FinishTransferScreen.route,
                                ModalRoute.withName(HomeScreen.route)),
                          },
                        );

                        break;
                      case Status.ERROR:
                        Future.delayed(
                          Duration.zero,
                          () => {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text(snapshot.data.message),
                              ),
                            )
                          },
                        );
                    }
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
