import 'package:app/Models/news_model.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Models/paginate_model.dart';
import 'package:app/Repositories/news_repository.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import '../bloc.dart';

class NewsDetailBloc implements Bloc {
  NewsRepository _newsRepository;
  StreamController _controller;

  StreamSink<ApiResponse<NewsModel>> get newsDetailSink => _controller.sink;

  Stream<ApiResponse<NewsModel>> get newsDetailStream => _controller.stream;

  NewsDetailBloc() {
    _controller = StreamController<ApiResponse<NewsModel>>();
    _newsRepository = NewsRepository();
  }

  fetchNewsDetail(int a) async {
    newsDetailSink.add(ApiResponse.loading('Đang lấy dữ liệu tin tức'));
    try {
      NewsModel newsDetail = await _newsRepository.fetchNewsDetail(id: a);
      newsDetailSink.add(ApiResponse.completed(newsDetail));
    } catch (e) {
      newsDetailSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  @override
  void dispose() {
    _controller.close();
  }
}
