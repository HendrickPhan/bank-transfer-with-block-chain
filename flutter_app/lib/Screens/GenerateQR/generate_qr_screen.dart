import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class GenerateQRScreen extends StatefulWidget {
  static const String route = "generate_qr";

  final String accountNumber;

  GenerateQRScreen({Key key, @required this.accountNumber}) : super(key: key);

  @override
  GenerateQRScreenState createState() => GenerateQRScreenState();
}

class GenerateQRScreenState extends State<GenerateQRScreen> {
  Uint8List bytes = Uint8List(0);

  @override
  initState() {
    super.initState();
    _generateBarCode(widget.accountNumber);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('QR code of: ' + widget.accountNumber),
          leading: BackButton(
            color: Colors.white,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        backgroundColor: Color(0xFF333333),
        body: Builder(
          builder: (BuildContext context) {
            return Center(
              child: Column(
                children: <Widget>[
                  _qrCodeWidget(this.bytes, context),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _qrCodeWidget(Uint8List bytes, BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 190,
                child: bytes.isEmpty
                    ? Center(
                        child: Text('Empty code ... ',
                            style: TextStyle(color: Colors.black38)),
                      )
                    : Image.memory(bytes),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _generateBarCode(String inputCode) async {
    Uint8List result = await scanner.generateBarCode(inputCode);
    this.setState(() => this.bytes = result);
  }
}
