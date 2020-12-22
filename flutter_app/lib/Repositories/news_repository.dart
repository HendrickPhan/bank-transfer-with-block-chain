import 'dart:async';
import 'package:app/Models/news_model.dart';
import 'package:app/Models/bank_account_list_model.dart';
import 'package:app/Models/paginate_model.dart';
import 'package:app/Networking/api_provider.dart';
import 'package:flutter/cupertino.dart';

class NewsRepository {
  ApiProvider _provider = ApiProvider();

  Future<PaginateModel<NewsModel>> fetchNewsListData({int page = 1}) async {
    final response = await _provider.get(url: "news?page=" + page.toString());
    return PaginateModel<NewsModel>.fromJson(
        (json) => new NewsModel.fromJson(json), response);
  }

  Future<NewsModel> fetchNewsDetail({int id}) async {
    final response = await _provider.get(url: "news/" + id.toString());
    return NewsModel.fromJson(response);
  }
}
