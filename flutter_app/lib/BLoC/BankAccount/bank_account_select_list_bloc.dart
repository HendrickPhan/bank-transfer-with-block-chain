import 'package:app/Models/bank_account_model.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Models/paginate_model.dart';
import 'package:app/Models/bank_account_list_model.dart';
import 'package:app/Repositories/bank_account_repository.dart';
import 'dart:async';
import 'package:app/Ultilities/log.dart';
import '../bloc.dart';

class BankAccountSelectListBloc implements Bloc {
  BankAccountRepository _repository;
  StreamController _controller;

  StreamSink<ApiResponse<List<BankAccountModel>>>
      get bankAccountSelectListSink => _controller.sink;

  Stream<ApiResponse<List<BankAccountModel>>> get bankAccountSelectListStream =>
      _controller.stream;

  BankAccountSelectListBloc() {
    _controller = StreamController<ApiResponse<List<BankAccountModel>>>();
    _repository = BankAccountRepository();
  }

  fetchBankAccountSelectLists() async {
    bankAccountSelectListSink.add(ApiResponse.loading('Đang lấy dữ liệu ví'));
    try {
      List<BankAccountModel> selectList =
          await _repository.fetchBankAccountSelectListData();
      bankAccountSelectListSink.add(ApiResponse.completed(selectList));
    } catch (e) {
      bankAccountSelectListSink.add(ApiResponse.error(e.toString()));
      Log.error(e.toString());
    }
  }

  @override
  void dispose() {
    _controller.close();
  }
}
