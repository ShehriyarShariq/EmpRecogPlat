import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  final String id, title, message;
  final DateTime timestamp;

  NotificationModel({this.id, this.title, this.message, this.timestamp});

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json['id'],
        title: json['title'],
        message: json['message'],
        timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
      );

  @override
  List<Object> get props => [title, message, timestamp];
}
