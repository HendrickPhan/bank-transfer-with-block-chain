import 'package:flutter/material.dart';
import 'package:app/BLoC/login_bloc.dart';
import 'package:app/Models/user_model.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Widget/Loading/loading_widget.dart';
import 'package:app/main.dart';
import 'package:app/Screens/Register/register_screen.dart';
import 'package:app/Animation/FadeAnimation.dart';

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
        backgroundColor: Colors.white,
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
                          title: new Text("Error"),
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
                  Container(
                    height: 400,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/background.png'),
                            fit: BoxFit.fill)),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 30,
                          width: 80,
                          height: 200,
                          child: FadeAnimation(
                              1,
                              Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/light-1.png'))),
                              )),
                        ),
                        Positioned(
                          left: 140,
                          width: 80,
                          height: 150,
                          child: FadeAnimation(
                              1.3,
                              Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/light-2.png'))),
                              )),
                        ),
                        Positioned(
                          right: 40,
                          top: 40,
                          width: 80,
                          height: 150,
                          child: FadeAnimation(
                              1.5,
                              Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/clock.png'))),
                              )),
                        ),
                        Positioned(
                          child: FadeAnimation(
                              1.6,
                              Container(
                                margin: EdgeInsets.only(top: 50),
                                child: Center(
                                  child: Text(
                                    "Đăng nhập",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Column(
                      children: <Widget>[
                        FadeAnimation(
                            1.8,
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            Color.fromRGBO(143, 148, 251, .2),
                                        blurRadius: 20.0,
                                        offset: Offset(0, 10))
                                  ]),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[100]))),
                                    child: TextFormField(
                                      controller: phoneNumberController,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Phone Number",
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
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: passwordController,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Password",
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
                                  )
                                ],
                              ),
                            )),
                        FadeAnimation(
                            2,
                            Container(
                              margin: const EdgeInsets.only(top: 20.0),
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(colors: [
                                    Color.fromRGBO(143, 148, 251, 1),
                                    Color.fromRGBO(143, 148, 251, .6),
                                  ])),
                              child: Center(
                                child: FlatButton(
                                    onPressed: loginBtnClick,
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ),
                            )),
                        SizedBox(
                          height: 70,
                        ),
                        FadeAnimation(
                            1.5,
                            Text(
                              "Forgot Password?",
                              style: TextStyle(
                                  color: Color.fromRGBO(143, 148, 251, 1)),
                            )),
                      ],
                    ),
                  )
                ],
              ),
            )));
          },
        ));
  }

  void loginBtnClick() {
    if (_formKey.currentState.validate()) {
      String phoneNumber = phoneNumberController.text;
      String password = passwordController.text;
      _bloc.login(phoneNumber: phoneNumber, password: password);
    }
  }
}
