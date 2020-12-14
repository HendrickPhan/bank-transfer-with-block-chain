import 'package:flutter/material.dart';
import 'BLoC/check_logged_in_bloc.dart';
import 'Screens/Login/login_screen.dart';
import 'Screens/Profile/profile_screen.dart';
import 'Screens/History/history_list_screen.dart';
import 'Screens/DailyMonth/daily_month_screen.dart';
import 'Screens/CreateTransaction/create_transaction_screen.dart';
import 'Screens/BankAccount/bank_account_list_screen.dart';
import 'Screens/BankAccount/bank_account_create_screen.dart';
import 'Screens/CreateTransaction/create_transaction_screen.dart';
import 'Screens/Beneficiary/beneficiary_account_list_screen.dart';
import 'Screens/Beneficiary/create_beneficiary_account_screen.dart';
import 'Screens/News/news_screen.dart';
import 'Screens/News/news_detail_screen.dart';
import 'Screens/News/news_detail_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to flutter app  ',
      home: Center(
        child: Main(index: 0),
      ),
    );
  }
}

class Main extends StatefulWidget {
  final index;
  Main({this.index});
  @override
  _MainState createState() => _MainState(a: index);
}

class _MainState extends State<Main> {
  final a;
  _MainState({this.a});

  CheckLoggedInBloc _bloc;
  int _currentIndex;
  final List<Widget> _children = [
    BankAccountListScreen(),
    CreateTransactionScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _bloc = CheckLoggedInBloc();
    _bloc.checkLogged();
    if (a != null) {
      _currentIndex = a;
    } else
      _currentIndex = 0;
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _bloc.checkLoggedInStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data) {
            return Container(
              child: Scaffold(
                body: _children[_currentIndex],
                bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.account_balance_wallet),
                      title: Text('Bank Accounts'),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.attach_money),
                      title: Text('Chuyển tiền'),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.account_circle),
                      title: Text('Tài khoản'),
                    ),
                  ],
                  currentIndex: _currentIndex != null ? _currentIndex : 0,
                  onTap: onTabTapped,
                  selectedItemColor: Colors.blue,
                  unselectedItemColor: Colors.blueGrey,
                ),
              ),
            );
          }
        }
        return LoginScreen();
      },
    );
  }
}
