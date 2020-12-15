import 'package:app/Models/news_model.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Models/paginate_model.dart';
import 'package:app/Models/bank_account_list_model.dart';
import 'package:app/Repositories/news_repository.dart';
import 'dart:async';
import '../bloc.dart';

class NewsListBloc implements Bloc {
  NewsRepository _newsRepository;
  StreamController _walletListController;

  StreamSink<ApiResponse<PaginateModel<NewsModel>>> get bankAccountListSink =>
      _walletListController.sink;

  Stream<ApiResponse<PaginateModel<NewsModel>>> get bankAccountListStream =>
      _walletListController.stream;

  NewsListBloc() {
    _walletListController =
        StreamController<ApiResponse<PaginateModel<NewsModel>>>();
    _newsRepository = NewsRepository();
  }

  fetchNewsLists() async {
    bankAccountListSink.add(ApiResponse.loading('Đang lấy tin tức'));
    try {
      PaginateModel bankAccountList =
          await _newsRepository.fetchNewsListData(page: 1);
      bankAccountListSink.add(ApiResponse.completed(bankAccountList));
    } catch (e) {
      bankAccountListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  fetchMoreNews(int page) async {
    try {
      PaginateModel bankAccountList =
          await _newsRepository.fetchNewsListData(page: page);
      bankAccountListSink.add(ApiResponse.completed(bankAccountList));
    } catch (e) {
      bankAccountListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  @override
  void dispose() {
    _walletListController.close();
  }
}
