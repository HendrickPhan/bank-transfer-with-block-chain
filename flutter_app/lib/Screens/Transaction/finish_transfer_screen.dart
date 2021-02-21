import 'package:flutter/material.dart';
import 'package:app/Screens/Home/home_screen.dart';

class FinishTransferScreen extends StatefulWidget {
  static const String route = "finish_transfer";
  final String message;
  final bool isSuccess;

  const FinishTransferScreen({
    Key key,
    this.message,
    this.isSuccess,
  }) : super(key: key);

  @override
  _FinishTransferScreenState createState() => _FinishTransferScreenState();
}

class _FinishTransferScreenState extends State<FinishTransferScreen> {
  @override
  void initState() {
    super.initState();
  }

  void onPressedSubmit() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Successful',
            style: TextStyle(color: Colors.white, fontSize: 20)),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: Color(0xFF222222),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Colors.white,
                Color(0xFFA5A5A5),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              tileMode: TileMode.clamp),
        ),
        constraints: BoxConstraints.expand(),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Text('YOUR TRANSFER SUBMITTED SUCCESSFULLY!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: new Text('Back to Home Page'),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        HomeScreen.route,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
