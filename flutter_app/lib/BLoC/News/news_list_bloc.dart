import 'package:app/Models/news_model.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Models/paginate_model.dart';
import 'package:app/Models/bank_account_list_model.dart';
import 'package:app/Repositories/news_repository.dart';
import 'dart:async';
import '../bloc.dart';

class NewsListBloc implements Bloc {
  NewsRepository _newsRepository;
  StreamController _controller;

  StreamSink<ApiResponse<PaginateModel<NewsModel>>> get newsListSink =>
      _controller.sink;

  Stream<ApiResponse<PaginateModel<NewsModel>>> get newsListStream =>
      _controller.stream;

  NewsListBloc() {
    _controller = StreamController<ApiResponse<PaginateModel<NewsModel>>>();
    _newsRepository = NewsRepository();
  }

  fetchNewsLists() async {
    newsListSink.add(ApiResponse.loading('Đang lấy tin tức'));
    try {
      PaginateModel newsList = await _newsRepository.fetchNewsListData(page: 1);
      newsListSink.add(ApiResponse.completed(newsList));
    } catch (e) {
      newsListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
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
    _controller.close();
  }
}
