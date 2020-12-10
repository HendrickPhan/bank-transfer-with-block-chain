import 'package:app/Screens/News/news_screen.dart';
import 'package:app/Screens/Profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/Models/user_model.dart';
import 'package:app/BLoC/User/user_bloc.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Models/user_model.dart';
import 'package:app/BLoC/User/user_bloc.dart';
import 'package:app/Widget/Error/err_widget.dart';
import 'package:app/Widget/Loading/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import './../BankAccount/bank_account_list_screen.dart';
import 'package:app/Screens/Login/login_screen.dart';
import 'package:app/Screens/History/history_list_screen.dart';
import 'package:app/Screens/CreateTransaction/create_transaction_screen.dart';
import 'package:app/main.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DrawerNav extends StatelessWidget {
  final String username;

  const DrawerNav({Key key, this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Main(index: 2)),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Main(index: 1)),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryListScreen()),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateTransactionScreen()),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewsScreen()),
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
              logout(),
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => LoginScreen()),
              // )
            },
          ),
        ],
      ),
      color: Colors.white,
    );
  }
}

// Future<Null> getToken() async {
//   _token = await _storage.read(key: "token");
//   debugPrint("TOKEN: " + _token);
// }
void logout() async {
  FlutterSecureStorage _storage = FlutterSecureStorage();

  await _storage.delete(key: 'token');
  String _token;
  _token = await _storage.read(key: "token");
  debugPrint("TOKEN: " + _token);
}
