import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:emp_recog_plat/features/notifications/data/model/notification_model.dart';
import 'package:equatable/equatable.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(Loading());

  @override
  Stream<NotificationState> mapEventToState(
    NotificationEvent event,
  ) async* {
    if (event is LoadNotificationsEvent) {
      yield Loading();
      final failureOrNotifications = await event.func();
      yield failureOrNotifications.fold((failure) => Error(),
          (notifications) => Loaded(notifications: notifications));
    }
  }
}
