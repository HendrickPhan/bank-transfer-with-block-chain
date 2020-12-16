import 'package:app/Networking/api_responses.dart';
import 'package:app/Models/wallet_list_model.dart';
import 'package:app/Repositories/wallet_list_repository.dart';
import 'package:app/Repositories/wallet_repository.dart';

import 'dart:async';
import 'bloc.dart';

class WalletListBloc implements Bloc {
  WalletListRepository _walletListRepository;
  WalletRepository _walletRepository;
  StreamController _walletListController;

  StreamSink<ApiResponse<WalletListModel>> get walletListSink =>
      _walletListController.sink;

  Stream<ApiResponse<WalletListModel>> get walletListStream =>
      _walletListController.stream;

  WalletListBloc() {
    _walletListController = StreamController<ApiResponse<WalletListModel>>();
    _walletListRepository = WalletListRepository();
    _walletRepository = WalletRepository();
  }

  fetchWalletLists() async {
    walletListSink.add(ApiResponse.loading('Đang lấy dữ liệu ví'));
    try {
      WalletListModel walletList =
          await _walletListRepository.fetchWalletListData(page: 1);
      walletListSink.add(ApiResponse.completed(walletList));
    } catch (e) {
      walletListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  addWallet() async {
    walletListSink.add(ApiResponse.loading('Đang lấy dữ liệu ví'));
    try {
      await _walletRepository.addWallet();
      // refetch list
      WalletListModel walletList =
          await _walletListRepository.fetchWalletListData(page: 1);
      walletListSink.add(ApiResponse.completed(walletList));
    } catch (e) {
      walletListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  @override
  void dispose() {
    _walletListController.close();
  }
}
