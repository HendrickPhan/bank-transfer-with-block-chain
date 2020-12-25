import 'dart:convert';

import 'package:app/Models/bank_account_model.dart';
import 'package:flutter/material.dart';
import 'package:app/BLoC/BankAccount/bank_account_detail_bloc.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Models/paginate_model.dart';
import 'package:app/Widget/Error/err_widget.dart';
import 'package:app/Widget/Loading/loading_widget.dart';
import 'package:app/Screens/GenerateQR/scan_qr_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:draft_flutter/draft_flutter.dart';

import 'package:flutter/material.dart';

class NewsDetailScreen extends StatefulWidget {
  @override
  _NewsDetailScreen createState() => _NewsDetailScreen();
}

class _NewsDetailScreen extends State<NewsDetailScreen> {
  Map<String, dynamic> testData = {
    "blocks": [
      {
        "key": "12do6",
        "text": "",
        "type": "unstyled",
        "depth": 0,
        "inlineStyleRanges": [],
        "entityRanges": [],
        "data": {}
      },
      {
        "key": "dknpg",
        "text": " ",
        "type": "atomic",
        "depth": 0,
        "inlineStyleRanges": [],
        "entityRanges": [
          {"offset": 0, "length": 1, "key": 0}
        ],
        "data": {}
      },
      {
        "key": "8h19a",
        "text": "mlem mlem",
        "type": "unstyled",
        "depth": 0,
        "inlineStyleRanges": [
          {"offset": 0, "length": 9, "style": "BOLD"}
        ],
        "entityRanges": [],
        "data": {}
      }
    ],
    "entityMap": {
      "0": {
        "type": "IMAGE",
        "mutability": "MUTABLE",
        "data": {
          "src":
              "http://bongda12h.com/wp-content/uploads/2020/12/anh-gai-xinh-de-thuong-mac-do-xuyen-thau-1024x725.jpg",
          "height": "auto",
          "width": "auto"
        }
      }
    }
  };
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        primaryTextTheme: TextTheme(
          bodyText1:
              TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
          headline3: TextStyle(color: Colors.black),
          headline4: TextStyle(color: Colors.black),
          headline5: TextStyle(color: Colors.black),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Draft"),
        ),
        body: DraftView(
          rawContentState: testData,
        ),
      ),
    );
  }
}
