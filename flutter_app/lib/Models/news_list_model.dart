import 'package:app/Models/model.dart';

typedef S ItemCreatorFromJson<S>(json);

class NewsListModel<T extends Model> {
  ItemCreatorFromJson<T> creator;
  List<T> data;
  int total;
  String path;

  NewsListModel({this.data, this.total, this.path});

  //new PaginateModel<UserListItem>.fromJson((json)=> new UserListItem.fromJson(json), json);
  factory NewsListModel.fromJson(
      ItemCreatorFromJson<T> creator, Map<String, dynamic> json) {
    List<T> _data = json['data'] != null
        ? List<T>.from(json["data"].map((i) => creator(i)))
        : null;

    return NewsListModel(
      data: _data,
      total: json['total'],
      path: json['path'],
    );
  }
}
