import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'package:app/Screens/Login/login_screen.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Models/user_model.dart';
import 'package:app/BLoC/User/user_bloc.dart';
import 'package:app/Widget/Error/err_widget.dart';
import 'package:app/Widget/Loading/loading_widget.dart';
import 'package:flutter/cupertino.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserBloc _bloc;
  //String _token;
  UserModel userDetail;

  @override
  void initState() {
    super.initState();
    //getToken();
    _bloc = UserBloc();
    _bloc.fetchUserDetail();
  }

  // Future<Null> getToken() async {
  //   _token = await _storage.read(key: "token");
  //   debugPrint("TOKEN: " + _token);
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Bank Accounts',
            style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: Color(0xFF222222),
      ),
      backgroundColor: Color(0xFF333333),
      body: NotificationListener<ScrollNotification>(
        child: StreamBuilder<ApiResponse>(
          stream: _bloc.userDetailStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return LoadingWidget(loadingMessage: snapshot.data.message);
                  break;
                case Status.COMPLETED:
                  userDetail = snapshot.data.data;
                  return UsertDetail(userDetail: userDetail);
                  break;
                case Status.ERROR:
                  return ErrWidget(
                    errorMessage: snapshot.data.message,
                  );
                  break;
              }
            }
            return Container();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // _bloc.addBankAccount();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.lightBlue,
      ),
    );
  }
}

class UsertDetail extends StatelessWidget {
  final UserModel userDetail;

  const UsertDetail({Key key, this.userDetail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tài Khoản'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Column(
                children: <Widget>[
                  Center(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          child: FloatingActionButton(
                            child: Icon(Icons.edit),
                            backgroundColor: Colors.transparent,
                            onPressed: () {},
                          ),
                          radius: 75,
                          backgroundImage: NetworkImage(
                              "https://img.webmd.com/dtmcms/live/webmd/consumer_assets/site_images/article_thumbnails/reference_guide/outdoor_cat_risks_ref_guide/1800x1200_outdoor_cat_risks_ref_guide.jpg?resize=750px:*"),
                        )),
                  ),
                  Center(
                      child: Text(
                    userDetail.fullName.toString(),
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  SizedBox(
                    width: 150,
                    child: Container(
                      child: RaisedButton(
                        onPressed: () => {
                          logout(),
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen())),
                        },
                        textColor: Colors.white,
                        color: Colors.blueGrey,
                        child: Text(
                          'Đăng xuất',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  void logout() async {
    FlutterSecureStorage _storage = FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }
}
