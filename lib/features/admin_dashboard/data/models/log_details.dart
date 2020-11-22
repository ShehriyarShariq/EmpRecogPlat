import 'package:equatable/equatable.dart';

class LogDetails extends Equatable {
  final String id, userID, message;
  final DateTime timestamp;

  LogDetails({this.id, this.userID, this.message, this.timestamp});

  factory LogDetails.fromJson(Map<String, dynamic> json) => LogDetails(
      id: json['id'],
      userID: json['userID'],
      message: json['message'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']));

  @override
  List<Object> get props => [id, userID, message, timestamp];
}
