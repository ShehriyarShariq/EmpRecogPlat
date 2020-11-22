part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class LoadNotificationsEvent extends NotificationEvent {
  final Function func;

  LoadNotificationsEvent({this.func}) : super([func]);
}