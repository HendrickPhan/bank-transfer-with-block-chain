import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'package:app/Screens/Login/login_screen.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Models/user_model.dart';
import 'package:app/BLoC/user_bloc.dart';
import 'package:app/Widget/Error/err_widget.dart';
import 'package:app/Widget/Loading/loading_widget.dart';
import 'package:flutter/cupertino.dart';
//import './../Drawer/drawer.dart';
//import 'package:app/BLoC/check_logged_in_bloc.dart';

class ProfileScreen extends StatefulWidget {
  static const String route = "profile";
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
      backgroundColor: Color(0xFF333333),
      body: NotificationListener<ScrollNotification>(
        child: StreamBuilder<ApiResponse>(
          stream: _bloc.userStream,
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
          title: Text('Profile'),
        ),
        //drawer: Container(width: 250, child: Drawer(child: DrawerNav())),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                Colors.white,
                Color(0xFF4E54C8),
              ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  tileMode: TileMode.clamp)),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 12.0, right: 12.0, top: 30.0, bottom: 8.0),
              ),
              Expanded(
                  child: Padding(
                padding:
                    const EdgeInsets.only(left: 12.0, top: 40.0, right: 12.0),
                child: ListView(children: <Widget>[
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
                  SizedBox(
                    height: 35,
                  ),
                  Card(
                    color: Colors.transparent,
                    elevation: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        buildTextField(
                            "Full Name", userDetail.name.toString(), false),
                        buildTextField("Phone Number",
                            userDetail.phoneNumber.toString(), false),
                        Text(
                          'Address:',
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                        SelectableText(
                          userDetail.address.toString(),
                          cursorColor: Colors.red,
                          showCursor: true,
                          toolbarOptions: ToolbarOptions(
                              copy: true,
                              selectAll: true,
                              cut: false,
                              paste: false),
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // RaisedButton(
                            //   onPressed: () => {
                            //     logout(),
                            //     Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //             builder: (context) => LoginScreen())),
                            //   },
                            //   color: Colors.green,
                            //   padding: EdgeInsets.symmetric(horizontal: 50),
                            //   elevation: 2,
                            //   shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(20)),
                            //   child: Text(
                            //     "Đăng xuất",
                            //     style: TextStyle(
                            //         fontSize: 14,
                            //         letterSpacing: 2.2,
                            //         color: Colors.white),
                            //   ),
                            // ),
                          ],
                        )
                      ],
                    ),
                  ),
                ]),
              ))
            ],
          ),
        ));
  }

  void logout() async {
    FlutterSecureStorage _storage = FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        enabled: false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                  )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.black54),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }
}
