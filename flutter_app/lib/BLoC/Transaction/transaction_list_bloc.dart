import 'package:app/Models/bank_account_model.dart';
import 'package:app/Networking/api_responses.dart';
import 'package:app/Models/paginate_model.dart';
import 'package:app/Models/transaction_model.dart';
import 'package:app/Repositories/transaction_repository.dart';
import 'dart:async';
import '../bloc.dart';
import 'package:flutter/cupertino.dart';

class TransactionListBloc implements Bloc {
  TransactionRepository _transactionRepository;
  StreamController _transactionListController;

  StreamSink<ApiResponse<PaginateModel<TransactionModel>>>
      get transactionListSink => _transactionListController.sink;

  Stream<ApiResponse<PaginateModel<TransactionModel>>>
      get transactionListStream => _transactionListController.stream;

  TransactionListBloc() {
    _transactionListController =
        StreamController<ApiResponse<PaginateModel<TransactionModel>>>();
    _transactionRepository = TransactionRepository();
  }

  fetchTransactionLists() async {
    transactionListSink.add(ApiResponse.loading('Đang lấy dữ người dùng'));
    try {
      PaginateModel transactionList =
          await _transactionRepository.getAllTransactions(page: 1);
      transactionListSink.add(ApiResponse.completed(transactionList));
    } catch (e) {
      transactionListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  fetchTransactionListsById(String bankAccountID) async {
    transactionListSink.add(ApiResponse.loading('Đang lấy dữ liệu người dùng'));
    try {
      PaginateModel transactionList = await _transactionRepository
          .getAllTransactionsById(bankAccountID: bankAccountID);
      transactionListSink.add(ApiResponse.completed(transactionList));
    } catch (e) {
      transactionListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  fetchMoreTransaction(int page) async {
    try {
      PaginateModel bankAccountList =
          await _transactionRepository.fetchTransactionListData(page: page);
      transactionListSink.add(ApiResponse.completed(bankAccountList));
    } catch (e) {
      transactionListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  @override
  void dispose() {
    _transactionListController.close();
  }
}
