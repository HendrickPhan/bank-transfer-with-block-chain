import 'package:app/Models/bills_model.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Models/paginate_model.dart';
import 'package:app/Models/bills_list_model.dart';
import 'package:app/Repositories/bills_repository.dart';
import 'dart:async';
import '../bloc.dart';

class BillsListBloc implements Bloc {
  BillsRepository _billsRepository;
  StreamController _billsListController;

  StreamSink<ApiResponse<PaginateModel<BillsModel>>> get billsListSink =>
      _billsListController.sink;

  Stream<ApiResponse<PaginateModel<BillsModel>>> get billsListStream =>
      _billsListController.stream;

  BillsListBloc() {
    _billsListController =
        StreamController<ApiResponse<PaginateModel<BillsModel>>>();
    _billsRepository = BillsRepository();
  }

  fetchBillsLists() async {
    billsListSink.add(ApiResponse.loading('Đang lấy dữ liệu hóa đơn'));
    try {
      PaginateModel billsList =
          await _billsRepository.fetchBillsListData(page: 1);
      billsListSink.add(ApiResponse.completed(billsList));
    } catch (e) {
      billsListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  fetchMoreBills(int page) async {
    try {
      PaginateModel billsList =
          await _billsRepository.fetchBillsListData(page: page);
      billsListSink.add(ApiResponse.completed(billsList));
    } catch (e) {
      billsListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  @override
  void dispose() {
    _billsListController.close();
  }
}
