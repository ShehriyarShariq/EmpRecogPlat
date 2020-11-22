import 'package:dartz/dartz.dart';
import 'package:emp_recog_plat/core/error/failures.dart';
import 'package:emp_recog_plat/features/notifications/data/model/notification_model.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, List<NotificationModel>>> getUserNotifications();
}
