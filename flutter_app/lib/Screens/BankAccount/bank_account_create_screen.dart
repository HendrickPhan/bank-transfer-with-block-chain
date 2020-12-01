import 'package:flutter/material.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

class BankAccountCreateScreen extends StatefulWidget {
  @override
  _BankAccountCreate createState() => _BankAccountCreate();
}

var cardAspectRatio = 12.0 / 16.0;
var widgetAspectRatio = cardAspectRatio * 1.2;

class _BankAccountCreate extends State<BankAccountCreateScreen> {
  String _myActivity;
  String _myActivityResult;
  final formKey = new GlobalKey<FormState>();

  void initState() {
    super.initState();
    _myActivity = '';
    _myActivityResult = '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
        child: DraggableScrollableSheet(builder: (context, scrollController) {
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
                                    onSaved: (value) {
                                      setState(() {
                                        _myActivity = value;
                                      });
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        _myActivity = value;
                                      });
                                    },
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
                                  padding: EdgeInsets.all(16),
                                  child: DropDownFormField(
                                    titleText: 'Type',
                                    hintText: 'Please choose type',
                                    value: _myActivity,
                                    onSaved: (value) {
                                      setState(() {
                                        _myActivity = value;
                                      });
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        _myActivity = value;
                                      });
                                    },
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
                                        //onPressed: loginBtnClick,
                                        child: Text(
                                      "Create",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(16),
                                  child: Text(_myActivityResult),
                                )
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
        }));
  }
}
