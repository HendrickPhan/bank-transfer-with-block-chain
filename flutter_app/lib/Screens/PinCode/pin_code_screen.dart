import 'package:app/Screens/Profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'package:app/Screens/Login/login_screen.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Models/user_model.dart';
import 'package:app/BLoC/active_pin_code.dart';
import 'package:app/Widget/Error/err_widget.dart';
import 'package:app/Widget/Loading/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import '../Drawer/drawer.dart';
import 'package:app/BLoC/check_logged_in_bloc.dart';

class PinCodeScreen extends StatefulWidget {
  @override
  _PinCodeScreenState createState() => _PinCodeScreenState();
}

class _PinCodeScreenState extends State<PinCodeScreen> {
  TextEditingController pinCodeController = TextEditingController();

  PinCodeBloc _bloc = PinCodeBloc();
  @override
  void initState() {
    super.initState();
    _bloc = PinCodeBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder<ApiResponse<String>>(
            stream: _bloc.pinCodeStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data.status) {
                  case Status.LOADING:
                    return LoadingWidget(loadingMessage: snapshot.data.message);
                    break;
                  case Status.COMPLETED:
                    // Future.delayed(
                    //   Duration.zero,
                    //   () => {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => ProfileScreen()),
                    //     )
                    //   },
                    // );
                    break;
                  case Status.ERROR:
                    return ErrWidget(
                      errorMessage: snapshot.data.message,
                    );
                    break;
                }
              }
              return Container(
                  child: Scaffold(
                      appBar: AppBar(
                        title: Text('Pin Code'),
                      ),
                      body: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                              Colors.white,
                              Colors.white,
                            ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                tileMode: TileMode.clamp)),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 12.0,
                                  right: 12.0,
                                  top: 30.0,
                                  bottom: 8.0),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, top: 20.0, right: 20.0),
                                child: ListView(
                                  children: <Widget>[
                                    Card(
                                        margin: EdgeInsets.all(5),
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Colors.white70, width: 1),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        elevation: 5,
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0,
                                                right: 12.0,
                                                top: 10.0,
                                                bottom: 8.0),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Center(
                                                      child: Text(
                                                    'Acitve Pin Code',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15),
                                                    textAlign: TextAlign.center,
                                                  )),
                                                  TextFormField(
                                                    controller:
                                                        pinCodeController,
                                                    decoration: InputDecoration(
                                                        hintText:
                                                            "Your Pin Code",
                                                        fillColor: Colors.black,
                                                        hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey[400])),
                                                    validator: (value) {
                                                      if (value.isEmpty) {
                                                        return 'Invalid';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                  SizedBox(
                                                    height: 35,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        gradient:
                                                            LinearGradient(
                                                                colors: [
                                                              Color.fromRGBO(
                                                                  143,
                                                                  148,
                                                                  251,
                                                                  1),
                                                              Color.fromRGBO(
                                                                  143,
                                                                  148,
                                                                  251,
                                                                  .6),
                                                            ])),
                                                    child: Center(
                                                      child: FlatButton(
                                                          onPressed:
                                                              sendBtnClick,
                                                          child: Text(
                                                            "Active",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )),
                                                    ),
                                                  ),
                                                ]))),
                                  ],
                                ),
                              ),
                              flex: 2,
                            ),
                          ],
                        ),
                      )));
            }));
  }

  void sendBtnClick() {
    String _pinCode = pinCodeController.text;
    debugPrint('xxx');
    _bloc.activePinCode(pinCode: _pinCode);
  }
}
