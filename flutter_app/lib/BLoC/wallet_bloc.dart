import 'package:app/Networking/api_responses.dart';
import 'package:app/Models/wallet_model.dart';
import 'package:app/Repositories/wallet_repository.dart';

import 'dart:async';
import 'bloc.dart';

class WalletBloc implements Bloc {
  WalletRepository _walletRepository;
  StreamController _walletController;

  StreamSink<ApiResponse<WalletModel>> get walletSink => _walletController.sink;

  Stream<ApiResponse<WalletModel>> get walletStream => _walletController.stream;

  WalletBloc() {
    _walletController = StreamController<ApiResponse<WalletModel>>();
    _walletRepository = WalletRepository();
  }

  fetchWallet() async {
    walletSink.add(ApiResponse.loading('Đang lấy dữ liệu ví'));
    try {
      WalletModel wallet = await _walletRepository.fetchWalletData(walletId: 1);
      walletSink.add(ApiResponse.completed(wallet));
    } catch (e) {
      walletSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  @override
  void dispose() {
    _walletController.close();
  }
}
