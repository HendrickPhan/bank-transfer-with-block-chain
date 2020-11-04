import 'package:app/Models/bank_account_model.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Models/paginate_model.dart';
import 'package:app/Repositories/bank_account_repository.dart';
import 'dart:async';
import '../bloc.dart';

class BankAccountListBloc implements Bloc {
  BankAccountRepository _bankAccountRepository;
  StreamController _walletListController;

  StreamSink<ApiResponse<PaginateModel<BankAccountModel>>>
      get bankAccountListSink => _walletListController.sink;

  Stream<ApiResponse<PaginateModel<BankAccountModel>>>
      get bankAccountListStream => _walletListController.stream;

  BankAccountListBloc() {
    _walletListController =
        StreamController<ApiResponse<PaginateModel<BankAccountModel>>>();
    _bankAccountRepository = BankAccountRepository();
  }

  fetchBankAccountLists() async {
    bankAccountListSink.add(ApiResponse.loading('Đang lấy dữ liệu ví'));
    try {
      PaginateModel bankAccountList =
          await _bankAccountRepository.fetchBankAccountListData(page: 1);
      bankAccountListSink.add(ApiResponse.completed(bankAccountList));
    } catch (e) {
      bankAccountListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  fetchMoreBankAccounts(int page) async {
    try {
      PaginateModel bankAccountList =
          await _bankAccountRepository.fetchBankAccountListData(page: page);
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
