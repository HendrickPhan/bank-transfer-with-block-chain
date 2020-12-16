import 'package:app/Screens/Login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/BLoC/register_bloc.dart';
import 'package:app/Models/user_model.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Widget/Error/err_widget.dart';
import 'package:app/Widget/Loading/loading_widget.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  RegisterBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = new RegisterBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng ký'),
        backgroundColor: Color(0xFF222222),
      ),
      backgroundColor: Color(0xFF333333),
      body: StreamBuilder<ApiResponse<String>>(
        stream: _bloc.registerStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return LoadingWidget(loadingMessage: snapshot.data.message);
                break;
              case Status.COMPLETED:
                Future.delayed(
                  Duration.zero,
                  () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
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
                        content: new Text(snapshot.data.message),
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
                        controller: usernameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Tên đăng nhập',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Không hợp lệ';
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
                          labelText: 'Mật khẩu',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Không hợp lệ';
                          }
                          return null;
                        },
                        obscureText: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: fullNameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Họ và tên',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Không hợp lệ';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Số điện thoại',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Không hợp lệ';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: addressController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Địa chỉ',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Không hợp lệ';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: RaisedButton(
                        onPressed: registerBtnClick,
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

  void registerBtnClick() {
    if (_formKey.currentState.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      UserModel user = new UserModel(
        username: usernameController.text,
        password: passwordController.text,
        address: addressController.text,
        fullName: fullNameController.text,
        phoneNumber: phoneController.text,
      );
      _bloc.register(user);
    }
  }
}
