import 'package:flutter/material.dart';
import 'package:app/BLoC/login_bloc.dart';
import 'package:app/Models/user_model.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Widget/Loading/loading_widget.dart';
import 'package:app/main.dart';
import 'package:app/Screens/Register/register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();

  LoginBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = new LoginBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng nhập'),
        backgroundColor: Color(0xFF222222),
      ),
      backgroundColor: Color(0xFF333333),
      body: StreamBuilder<ApiResponse<String>>(
        stream: _bloc.loginStream,
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
                      MaterialPageRoute(builder: (context) => Main()),
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
                        title: new Text("Lỗi"),
                        content: new Text((snapshot.data.message.toString() ==
                                '"Unauthorized"')
                            ? "Sai username hoặc password"
                            : snapshot.data.message),
                        actions: [
                          FlatButton(
                            onPressed: () =>
                                Navigator.pop(context, true), // passing true
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
          return Container(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: phoneNumberController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Phone Number',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Invalid';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Invalid';
                          }
                          return null;
                        },
                        obscureText: true,
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: RaisedButton(
                        onPressed: loginBtnClick,
                        textColor: Colors.white,
                        color: Colors.lightBlue,
                        child: Text(
                          'Đăng nhập',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: RaisedButton(
                        onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()),
                          )
                        },
                        textColor: Colors.white,
                        color: Colors.blueGrey,
                        child: Text(
                          'Đăng ký',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void loginBtnClick() {
    if (_formKey.currentState.validate()) {
      String phoneNumber = phoneNumberController.text;
      String password = passwordController.text;
      _bloc.login(phoneNumber: phoneNumber, password: password);
    }
  }
}
