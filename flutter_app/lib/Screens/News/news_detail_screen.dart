import 'dart:collection';
import 'dart:convert';

import 'package:app/Models/news_model.dart';
import 'package:flutter/material.dart';
import 'package:app/BLoC/News/news_detail_bloc.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Models/paginate_model.dart';
import 'package:app/Widget/Error/err_widget.dart';
import 'package:app/Widget/Loading/loading_widget.dart';

import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:draft_flutter/draft_flutter.dart';

import 'package:flutter/material.dart';

class NewsDetailScreen extends StatefulWidget {
  final int id;
  const NewsDetailScreen(this.id);
  @override
  _NewsDetailScreen createState() => _NewsDetailScreen();
}

class _NewsDetailScreen extends State<NewsDetailScreen> {
  NewsDetailBloc _bloc;
  NewsModel newsDetail;

  @override
  void initState() {
    super.initState();
    _bloc = NewsDetailBloc();
    _bloc.fetchNewsDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('News', style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: Color(0xFF333333),
        elevation: 0.0,
      ),
      body: NotificationListener<ScrollNotification>(
        child: StreamBuilder<ApiResponse>(
          stream: _bloc.newsDetailStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return LoadingWidget(loadingMessage: snapshot.data.message);
                  break;
                case Status.COMPLETED:
                  newsDetail = snapshot.data.data;
                  return NewsDetail(newsDetail: newsDetail);
                  break;
                case Status.ERROR:
                  return ErrWidget(
                    errorMessage: snapshot.data.message,
                  );
                  break;
              }
            }
            return Container();
          },
        ),
      ),
    );
  }
}

class NewsDetail extends StatelessWidget {
  final NewsModel newsDetail;
  NewsDetail({Key key, this.newsDetail}) : super(key: key);

  Map<String, dynamic> testData = {
    "blocks": [
      {
        "key": "anrdg",
        "text": "",
        "type": "unstyled",
        "depth": 0,
        "inlineStyleRanges": [],
        "entityRanges": [],
        "data": {}
      },
      {
        "key": "e6o0s",
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
        "key": "d69ei",
        "text": "Here you are BITCH",
        "type": "unstyled",
        "depth": 0,
        "inlineStyleRanges": [
          {"offset": 13, "length": 5, "style": "BOLD"}
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
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRO3NEyS1grXd3hl3NVU5i16KuMOprdP0ZHbA&usqp=CAU",
          "height": "auto",
          "width": "auto"
        }
      }
    }
  };
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> testData = new HashMap();
    testData = json.decode(newsDetail.body);

    return NotificationListener<ScrollNotification>(
      child: Scaffold(
        backgroundColor: Color(0xff4E295B),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
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
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: SingleChildScrollView(
                child: DraftView(
                  rawContentState: testData,
                ),
                // child: Text(testData.toString()),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
