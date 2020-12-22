import 'package:app/Models/news_list_model.dart';
import 'package:app/Models/news_model.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Models/paginate_model.dart';

import 'package:app/Repositories/news_repository.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import '../bloc.dart';

class NewsListBloc implements Bloc {
  NewsRepository _newsRepository;
  StreamController _newsListController;

  StreamSink<ApiResponse<PaginateModel<NewsModel>>> get newsListSink =>
      _newsListController.sink;

  Stream<ApiResponse<PaginateModel<NewsModel>>> get newsListStream =>
      _newsListController.stream;

  NewsListBloc() {
    _newsListController =
        StreamController<ApiResponse<PaginateModel<NewsModel>>>();
    _newsRepository = NewsRepository();
  }

  fetchNewsLists() async {
    newsListSink.add(ApiResponse.loading('Đang lấy dữ liệu tin tức'));
    try {
      PaginateModel newsList = await _newsRepository.fetchNewsListData(page: 1);
      newsListSink.add(ApiResponse.completed(newsList));
    } catch (e) {
      newsListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
    debugPrint('123');
  }

  fetchMoreNews(int page) async {
    try {
      PaginateModel newsList =
          await _newsRepository.fetchNewsListData(page: page);
      newsListSink.add(ApiResponse.completed(newsList));
    } catch (e) {
      newsListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  @override
  void dispose() {
    _newsListController.close();
  }
}
