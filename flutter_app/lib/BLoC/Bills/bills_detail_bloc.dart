import 'package:app/Models/bills_model.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Models/paginate_model.dart';
import 'package:app/Repositories/bills_repository.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import '../bloc.dart';

class BillsDetailBloc implements Bloc {
  BillsRepository _billsRepository;
  StreamController _billsListController;

  StreamSink<ApiResponse<BillsModel>> get billsDetailSink =>
      _billsListController.sink;

  Stream<ApiResponse<BillsModel>> get billsDetailStream =>
      _billsListController.stream;

  BillsDetailBloc() {
    _billsListController = StreamController<ApiResponse<BillsModel>>();
    _billsRepository = BillsRepository();
  }

  fetchBillsDetail(int a) async {
    billsDetailSink.add(ApiResponse.loading('Đang lấy dữ liệu hóa đơn'));
    try {
      BillsModel billsDetail = await _billsRepository.fetchBillsDetail(id: a);
      billsDetailSink.add(ApiResponse.completed(billsDetail));
    } catch (e) {
      billsDetailSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  @override
  void dispose() {
    _billsListController.close();
  }
}
