import 'dart:async';
import 'package:app/Models/bills_model.dart';
import 'package:app/Models/bills_list_model.dart';
import 'package:app/Models/paginate_model.dart';
import 'package:app/Networking/api_provider.dart';
import 'package:flutter/cupertino.dart';

class BillsRepository {
  ApiProvider _provider = ApiProvider();

  Future<PaginateModel<BillsModel>> fetchBillsListData({int page = 1}) async {
    final response = await _provider.get(url: "bill?page=" + page.toString());
    print(response.toString());
    return PaginateModel<BillsModel>.fromJson(
        (json) => new BillsModel.fromJson(json), response);
  }

  Future<List<BillsModel>> fetchBillsSelectListData() async {
    List<BillsModel> selectList = [];
    final response = await _provider.get(url: "bill/selections");

    for (final e in response) {
      selectList.add(BillsModel.fromJson(e));
    }

    return selectList;
  }

  Future<BillsModel> fetchBillsDetail({int id}) async {
    final response = await _provider.get(url: "bill/" + id.toString());
    return BillsModel.fromJson(response);
  }

  Future<BillsListModel> fetchBillsListDataForTransaction() async {
    final response = await _provider.get(url: "bill");
    return BillsListModel<BillsModel>.fromJson(
        (json) => new BillsModel.fromJson(json), response);
  }
}
