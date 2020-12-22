import 'package:app/Models/bank_account_list_model.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Models/paginate_model.dart';
import 'package:app/Repositories/bank_account_repository.dart';
import 'dart:async';
import '../bloc.dart';

class BankAccountListTransactionBloc implements Bloc {
  BankAccountRepository _bankAccountRepository;
  StreamController _walletListController;

  StreamSink<ApiResponse<BankAccountListModel>> get bankAccountListSink =>
      _walletListController.sink;

  Stream<ApiResponse<BankAccountListModel>> get bankAccountListStream =>
      _walletListController.stream;

  BankAccountListTransactionBloc() {
    _walletListController =
        StreamController<ApiResponse<BankAccountListModel>>();
    _bankAccountRepository = BankAccountRepository();
  }

  @override
  void dispose() {
    _walletListController.close();
  }

  fetchBankAccountListsForTransaction() async {
    bankAccountListSink
        .add(ApiResponse.loading('Đang lấy danh sách người dùng'));
    try {
      BankAccountListModel bankAccountListForTransaction =
          await _bankAccountRepository.fetchBankAccountListDataForTransaction();
      bankAccountListSink
          .add(ApiResponse.completed(bankAccountListForTransaction));
    } catch (e) {
      bankAccountListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }
}
