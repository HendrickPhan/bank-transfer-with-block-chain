import 'package:flutter/material.dart';
// ----- screen
import 'package:app/Screens/Home/home_screen.dart';
// BankAccountListScreen
// ----- bloc
import 'package:app/BLoC/activate_account_bloc.dart';
import 'package:app/BLoC/bloc_provider.dart';

// ----- widget
import 'package:app/Widget/drawer_widget.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import 'package:app/Networking/api_responses.dart';
import 'package:app/Models/user_model.dart';
import 'package:app/Widget/Error/err_widget.dart';
import 'package:app/Widget/Loading/loading_widget.dart';

import 'package:app/Ultilities/log.dart';

import 'package:flutter/gestures.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ActivateAccountScreen extends StatefulWidget {
  static const String route = "activate-account";

  const ActivateAccountScreen({Key key}) : super(key: key);

  @override
  _ActivateAccountScreenState createState() => _ActivateAccountScreenState();
}

class _ActivateAccountScreenState extends State<ActivateAccountScreen> {
  ActivateAccountBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<bool>>(
      stream: _bloc.activateAccountStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return LoadingWidget(loadingMessage: snapshot.data.message);
            case Status.COMPLETED:
              if (snapshot.data.data) {
                Future.delayed(Duration.zero, () {
                  Navigator.pushReplacementNamed(
                    context,
                    HomeScreen.route,
                  );
                });
              }
              break;
            case Status.ERROR:
              Future.delayed(Duration.zero, () {
                Navigator.pop(context);
              });
          }
        }
        return PinCodeVerificationScreen();
      },
    );
  }
}

class PinCodeVerificationScreen extends StatefulWidget {
  @override
  _PinCodeVerificationScreenState createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  var onTapRecognizer;
  ActivateAccountBloc _bloc;

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
    _bloc = BlocProvider.of(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                          _bloc.activate(pinCode: currentText);
                        });
                      }
                    },
                    child: Center(
                        child: Text(
                      "ACTIVATE".toUpperCase(),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
