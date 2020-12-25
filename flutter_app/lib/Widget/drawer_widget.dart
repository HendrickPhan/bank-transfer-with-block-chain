// import 'package:app/Screens/News/news_screen.dart';
import 'package:flutter/material.dart';
// ----- screens
import 'package:app/Screens/Login/login_screen.dart';
// import 'package:app/Screens/History/history_list_screen.dart';
// import 'package:app/Screens/CreateTransaction/create_transaction_screen.dart';
import 'package:app/Screens/Home/home_screen.dart';

import 'package:app/BLoC/auth_bloc.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final String username = "abc";
  AuthBloc authBloc;

  @override
  void initState() {
    super.initState();
    authBloc = AuthBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    width: 80,
                    height: 80,
                    margin: EdgeInsets.only(
                      top: 30,
                    ),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(
                                'https://img.webmd.com/dtmcms/live/webmd/consumer_assets/site_images/article_thumbnails/reference_guide/outdoor_cat_risks_ref_guide/1800x1200_outdoor_cat_risks_ref_guide.jpg?resize=750px:*'),
                            fit: BoxFit.fill)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(
              'Profile',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () => {
              Navigator.pushNamed(
                context,
                HomeScreen.route,
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.web),
            title: Text(
              'Bank Accounts',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () => {
              Navigator.pushNamed(
                context,
                HomeScreen.route,
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text(
              'History',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () => {
              Navigator.pushNamed(
                context,
                HomeScreen.route,
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.local_atm),
            title: Text(
              'Transactions',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () => {
              Navigator.pushNamed(
                context,
                HomeScreen.route,
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.insights),
            title: Text(
              'Statics',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: null,
          ),
          ListTile(
            leading: Icon(Icons.new_releases),
            title: Text(
              'News',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () => {
              Navigator.pushNamed(
                context,
                HomeScreen.route,
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.arrow_back),
            title: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            onTap: () => {
              authBloc.logout(),
              Navigator.pushNamed(
                context,
                LoginScreen.route,
              )
            },
          ),
        ],
      ),
    );
  }
}
