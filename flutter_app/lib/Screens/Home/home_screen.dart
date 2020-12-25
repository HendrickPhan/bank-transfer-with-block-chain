import 'package:flutter/material.dart';
// ----- screen
import 'package:app/Screens/BankAccount/bank_account_list_screen.dart';
// BankAccountListScreen
// ----- widget
import 'package:app/Widget/drawer_widget.dart';
import 'package:qrscan/qrscan.dart' as scanner;

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
    ScreenWithTitle(Container(), "News"),
  ];

  Future _scan() async {
    String barcode = await scanner.scan();
    print(barcode);
  }

  @override
  void initState() {
    super.initState();
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
      body: Container(
        child: currentScreen.screen,
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
            icon: Icon(Icons.notes),
            label: 'News',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
