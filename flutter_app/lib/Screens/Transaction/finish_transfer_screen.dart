import 'package:flutter/material.dart';

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
      body: Container(
        constraints: BoxConstraints.expand(),
        child: Text(
          "TRANSFER SUBMITTED",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
