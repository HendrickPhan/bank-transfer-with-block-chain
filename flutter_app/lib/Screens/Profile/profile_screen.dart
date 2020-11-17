import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'package:app/Screens/Login/login_screen.dart';
import 'package:app/Models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FlutterSecureStorage _storage = FlutterSecureStorage();

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
                    "Nguyễn Ái Vy",
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
                        onPressed: logout,
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
    await _storage.delete(key: 'token');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
