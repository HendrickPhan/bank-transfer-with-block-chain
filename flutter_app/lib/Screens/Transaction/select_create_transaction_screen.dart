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
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
              Colors.white,
              Color(0xFFA5A5A5),
            ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                tileMode: TileMode.clamp)),
        height: size.height,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                Text('Choose your transaction!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 20)),
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
          ]),
        ),
      ),
    );
  }
}
