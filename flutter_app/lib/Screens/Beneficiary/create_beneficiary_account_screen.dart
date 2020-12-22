import 'dart:async';
import 'dart:typed_data';

import 'package:app/Models/wallet_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:app/Networking/api_responses.dart';
import 'package:app/BLoC/wallet_list_bloc.dart';
import 'package:app/Models/wallet_list_model.dart';
import 'package:app/Widget/Error/err_widget.dart';
import 'package:app/Widget/Loading/loading_widget.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

class CreateBeneficiaryScreen extends StatefulWidget {
  @override
  _CreateBeneficiaryScreenState createState() =>
      _CreateBeneficiaryScreenState();
}

var cardAspectRatio = 12.0 / 16.0;
var widgetAspectRatio = cardAspectRatio * 1.2;

class _CreateBeneficiaryScreenState extends State<CreateBeneficiaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: <Widget>[
          Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30.0,
          ),
          SizedBox(
            width: 15,
          ),
          Container(
              //margin: EdgeInsets.fromLTRB(0, 0, 130, 0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                Container(
                  child: Text(
                    'Ov3rControl',
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
                SizedBox(height: 4.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.trip_origin,
                      color: Colors.orange,
                      size: 12.0,
                    ),
                    SizedBox(width: 4.0),
                    Text('1000', style: TextStyle(fontSize: 12.0))
                  ],
                ),
              ])),
        ],
      )),
      backgroundColor: Colors.transparent,
      body: Container(
        child: CreateTransaction(),
      ),
    );
  }
}

class CreateTransaction extends StatelessWidget {
  String _myActivity;
  String _myActivityResult;
  final formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    _myActivity = '';
    _myActivityResult = '';
  }

  Widget build(BuildContext context) {
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
                                        titleText: 'Bank',
                                        hintText: 'Please choose Bank',
                                        value: _myActivity,
                                        dataSource: [
                                          {
                                            "display": "Running",
                                            "value": "Running",
                                          },
                                          {
                                            "display": "Climbing",
                                            "value": "Climbing",
                                          },
                                          {
                                            "display": "Walking",
                                            "value": "Walking",
                                          },
                                          {
                                            "display": "Swimming",
                                            "value": "Swimming",
                                          },
                                          {
                                            "display": "Soccer Practice",
                                            "value": "Soccer Practice",
                                          },
                                          {
                                            "display": "Baseball Practice",
                                            "value": "Baseball Practice",
                                          },
                                          {
                                            "display": "Football Practice",
                                            "value": "Football Practice",
                                          },
                                        ],
                                        textField: 'display',
                                        valueField: 'value',
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 15.0, right: 15.0, top: 20.0),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            hintText: "Accpunt Address",
                                            fillColor: Colors.black,
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400])),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Invalid';
                                          }
                                          return null;
                                        },
                                        obscureText: true,
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
                                            //onPressed: loginBtnClick,
                                            child: Text(
                                          "Create",
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
}
