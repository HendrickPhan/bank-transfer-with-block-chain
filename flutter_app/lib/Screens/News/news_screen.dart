import 'package:flutter/material.dart';
import 'customIcons.dart';
import 'dart:math';
import 'package:app/BLoC/News/news_list_bloc.dart';
import 'package:app/Models/paginate_model.dart';
import 'package:app/Models/news_model.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Widget/Error/err_widget.dart';
import 'package:app/Widget/Loading/loading_widget.dart';
import 'package:app/Screens/News/news_detail_screen.dart';

var cardAspectRatio = 12.0 / 16.0;
var widgetAspectRatio = cardAspectRatio * 1.2;
List<String> images = [
  "assets/images/image_04.jpg",
  "assets/images/image_03.jpg",
  "assets/images/image_02.jpg",
  "assets/images/image_01.png",
];

class NewsScreen extends StatefulWidget {
  static const String route = "news";
  @override
  _NewsScreen createState() => _NewsScreen();
}

class _NewsScreen extends State<NewsScreen> {
  var currentPage = images.length - 1.0;
  NewsListBloc _bloc;
  int page;
  bool loadingNewPage;
  bool allPageLoaded;
  PaginateModel<NewsModel> newsList;
  ScrollController controller = ScrollController();

  void _scrollListener() {
    if (controller.position.extentAfter < 500 &&
        !allPageLoaded &&
        !loadingNewPage) {
      page++;
      _bloc.fetchMoreNews(page);
      loadingNewPage = true;
    }
  }

  @override
  void initState() {
    loadingNewPage = false;
    allPageLoaded = false;
    page = 1;
    super.initState();
    _bloc = NewsListBloc();
    _bloc.fetchNewsLists();
    controller.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('News', style: TextStyle(color: Colors.white, fontSize: 20)),
        elevation: 0.0,
      ),
      body: StreamBuilder<ApiResponse<PaginateModel>>(
        stream: _bloc.newsListStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return LoadingWidget(loadingMessage: snapshot.data.message);
                break;
              case Status.COMPLETED:
                if (newsList == null) {
                  newsList = snapshot.data.data;
                } else {
                  snapshot.data.data.data.forEach((element) {
                    newsList.data.add(element);
                  });
                  allPageLoaded = snapshot.data.data.currentPage >=
                      snapshot.data.data.lastPage;
                  loadingNewPage = false;
                }
                return NewsList(
                  newsList: newsList,
                  controller: controller,
                );
                break;
              case Status.ERROR:
                return ErrWidget(
                  errorMessage: snapshot.data.message,
                  onRetryPressed: () => _bloc.fetchNewsLists(),
                );
                break;
            }
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // _bloc.addBankAccount();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.lightBlue,
      ),
    );
  }
}

class NewsList extends StatelessWidget {
  final PaginateModel<NewsModel> newsList;
  final ScrollController controller;
  const NewsList({Key key, this.newsList, this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
            Colors.white,
            Color(0xFF4E54C8),
          ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              tileMode: TileMode.clamp)),
      height: size.height,
      child: new ListView.builder(
        controller: controller,
        itemBuilder: (context, index) {
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    child: InkWell(
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  NewsDetailScreen(newsList.data[index].id)),
                        )
                      },
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.stretch, // add this
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0),
                            ),
                            child: Image.asset(
                              'assets/images/image_01.png',
                              height: 150,
                              fit: BoxFit.fill,
                            ),
                          ),
                          ListTile(
                            title: Text(
                              newsList.data[index].title,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              newsList.data[index].body.substring(0, 100) +
                                  '...',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        itemCount: newsList.data.length,
      ),
    );
  }
}
