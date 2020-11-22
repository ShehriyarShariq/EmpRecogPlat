part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  const NotificationState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class Loading extends NotificationState {}

class Loaded extends NotificationState {
  final List<NotificationModel> notifications;

  Loaded({this.notifications}) : super([notifications]);
}

class Error extends NotificationState {}
