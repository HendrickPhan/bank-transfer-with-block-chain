import 'package:flutter/material.dart';
import 'package:app/Screens/Transaction/create_transfer_screen.dart';
import 'package:app/Screens/Transaction/create_cash_out_screen.dart';

class SelectCreateTransactionScreen extends StatefulWidget {
  static const String route = "select-create-transaction";

  @override
  _SelectCreateTransactionScreenState createState() =>
      _SelectCreateTransactionScreenState();
}

class _SelectCreateTransactionScreenState
    extends State<SelectCreateTransactionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            children: [
              RaisedButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: new Text('Transfer'),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    CreateTransferScreen.route,
                  );
                },
              ),
              RaisedButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: new Text('Cash Out'),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    CreateCashOutScreen.route,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
