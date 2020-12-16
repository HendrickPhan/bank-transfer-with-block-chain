import 'package:app/Models/model.dart';

typedef S ItemCreatorFromJson<S>(json);

class PaginateModel<T extends Model> {
  ItemCreatorFromJson<T> creator;
  List<T> data;
  int currentPage;
  int lastPage;
  int from;
  int to;
  int perPage;
  int total;
  String firstPageUrl;
  String lastPageUrl;
  String nextPageUrl;
  String prevPageUrl;
  String path;

  PaginateModel(
      {this.data,
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

  //new PaginateModel<UserListItem>.fromJson((json)=> new UserListItem.fromJson(json), json);
  factory PaginateModel.fromJson(
      ItemCreatorFromJson<T> creator, Map<String, dynamic> json) {
    List<T> _data = json['data'] != null
        ? List<T>.from(json["data"].map((i) => creator(i)))
        : null;

    return PaginateModel(
      data: _data,
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
