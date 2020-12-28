import 'package:app/Models/model.dart';

class NotificationModel implements Model {
  final int id;
  final int userId;
  final String title;
  final String body;

  NotificationModel({
    this.id,
    this.userId,
    this.title,
    this.body,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      body: json['body'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['body'] = this.body;
    return data;
  }
}
