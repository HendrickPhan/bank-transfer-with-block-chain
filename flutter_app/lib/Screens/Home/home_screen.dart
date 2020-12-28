import 'package:flutter/material.dart';
// ----- screen
import 'package:app/Screens/BankAccount/bank_account_list_screen.dart';
// BankAccountListScreen
// ----- bloc
import 'package:app/BLoC/user_bloc.dart';

// ----- widget
import 'package:app/Widget/drawer_widget.dart';
import 'package:qrscan/qrscan.dart' as scanner;
// ----- screen
import 'package:app/Screens/ActivateAccount/activate_account_screen.dart';
import 'package:app/Screens/Transaction/select_create_transaction_screen.dart';

import 'package:app/Networking/api_responses.dart';
import 'package:app/Models/user_model.dart';
import 'package:app/Widget/Error/err_widget.dart';
import 'package:app/Widget/Loading/loading_widget.dart';

import 'package:app/Ultilities/log.dart';

class ScreenWithTitle {
  final Widget screen;
  final String title;
  const ScreenWithTitle(this.screen, this.title);
}

class HomeScreen extends StatefulWidget {
  static const String route = "home";
  final int initIndex;

  const HomeScreen({Key key, this.initIndex = 0}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String title = "Home";
  int _selectedIndex = 0;
  UserBloc _bloc;

  void _onItemTapped(int index) {
    if (index == 1) {
      _scan();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  static List<ScreenWithTitle> _widgetOptions = <ScreenWithTitle>[
    ScreenWithTitle(BankAccountListScreen(), "Bank Accounts"),
    ScreenWithTitle(Container(), "QR Scan"),
    ScreenWithTitle(SelectCreateTransactionScreen(), "Transaction"),
  ];

  Future _scan() async {
    String barcode = await scanner.scan();
    print(barcode);
  }

  @override
  void initState() {
    super.initState();
    _bloc = UserBloc();
    _bloc.fetchUserDetail();
    if (widget.initIndex != 0) {
      setState(() {
        _selectedIndex = widget.initIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenWithTitle currentScreen = _widgetOptions.elementAt(_selectedIndex);
    return Scaffold(
      appBar: AppBar(title: Text(currentScreen.title)),
      body: StreamBuilder<ApiResponse<UserModel>>(
        stream: _bloc.userStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return LoadingWidget(loadingMessage: snapshot.data.message);
              case Status.COMPLETED:
                UserModel userModel = snapshot.data.data;
                if (userModel.address == null) {
                  Log.debug("ok");
                  Future.delayed(Duration.zero, () {
                    Navigator.pushReplacementNamed(
                      context,
                      ActivateAccountScreen.route,
                    );
                  });
                }
                break;
              case Status.ERROR:
                return ErrWidget(
                  errorMessage: snapshot.data.message,
                  onRetryPressed: () => _bloc.fetchUserDetail(),
                );
            }
          }
          return Container(
            child: currentScreen.screen,
          );
        },
      ),
      drawer: DrawerWidget(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Bank Accounts',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.qr_code_scanner_outlined,
              size: 40.0,
              color: Colors.red,
            ),
            label: 'QR Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Transaction',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
