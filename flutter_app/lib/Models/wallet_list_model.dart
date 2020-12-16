import 'package:app/Models/wallet_model.dart';

class WalletListModel {
  final List<WalletModel> walletList;
  final int currentPage;
  final int lastPage;
  final int from;
  final int to;
  final int perPage;
  final int total;
  final String firstPageUrl;
  final String lastPageUrl;
  final String nextPageUrl;
  final String prevPageUrl;
  final String path;

  WalletListModel(
      {this.walletList,
      this.currentPage,
      this.lastPage,
      this.from,
      this.to,
      this.perPage,
      this.total,
      this.firstPageUrl,
      this.lastPageUrl,
      this.nextPageUrl,
      this.prevPageUrl,
      this.path});

  factory WalletListModel.fromJson(Map<String, dynamic> json) {
    List<WalletModel> walletList = json['data'] != null
        ? List<WalletModel>.from(
            json["data"].map((i) => new WalletModel.fromJson(i)))
        : null;

    return WalletListModel(
      walletList: walletList,
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      from: json['from'],
      to: json['to'],
      perPage: json['per_page'],
      total: json['total'],
      firstPageUrl: json['first_page_url'],
      lastPageUrl: json['last_page_url'],
      nextPageUrl: json['next_page_url'],
      prevPageUrl: json['prev_page_url'],
      path: json['path'],
    );
  }
}
