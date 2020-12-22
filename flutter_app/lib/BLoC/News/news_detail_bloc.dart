import 'package:app/Models/bank_account_model.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Models/paginate_model.dart';
import 'package:app/Repositories/bank_account_repository.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import '../bloc.dart';

class BankAccountDetailBloc implements Bloc {
  BankAccountRepository _bankAccountRepository;
  StreamController _walletListController;

  StreamSink<ApiResponse<BankAccountModel>> get bankAccountDetailSink =>
      _walletListController.sink;

  Stream<ApiResponse<BankAccountModel>> get bankAccountDetailStream =>
      _walletListController.stream;

  BankAccountDetailBloc() {
    _walletListController = StreamController<ApiResponse<BankAccountModel>>();
    _bankAccountRepository = BankAccountRepository();
  }

  fetchBankAccountDetail(int a) async {
    bankAccountDetailSink
        .add(ApiResponse.loading('Đang lấy dữ liệu người dùng'));
    try {
      BankAccountModel bankAccountDetail =
          await _bankAccountRepository.fetchBankAccountDetail(id: a);
      bankAccountDetailSink.add(ApiResponse.completed(bankAccountDetail));
    } catch (e) {
      bankAccountDetailSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  @override
  void dispose() {
    _walletListController.close();
  }
}
