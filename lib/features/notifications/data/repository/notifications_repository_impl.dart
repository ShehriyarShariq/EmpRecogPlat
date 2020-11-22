import 'package:dartz/dartz.dart';
import 'package:emp_recog_plat/core/error/failures.dart';
import 'package:emp_recog_plat/core/firebase/firebase.dart';
import 'package:emp_recog_plat/core/network/network_info.dart';
import 'package:emp_recog_plat/features/notifications/data/model/notification_model.dart';
import 'package:emp_recog_plat/features/notifications/domain/repository/notifications_repository.dart';

class NotificationsRepositoryImpl extends NotificationsRepository {
  final NetworkInfo networkInfo;

  NotificationsRepositoryImpl({this.networkInfo});

  @override
  Future<Either<Failure, List<NotificationModel>>>
      getUserNotifications() async {
    if (await networkInfo.isConnected) {
      try {
        print(FirebaseInit.auth.currentUser.uid);
        List<NotificationModel> notifications = await FirebaseInit.dbRef
            .child(
                "employee/${FirebaseInit.auth.currentUser.uid}/notifications")
            .once()
            .then((snapshot) {
          return snapshot.value == null
              ? []
              : List<dynamic>.from(snapshot.value.values.toList())
                  .map((e) =>
                      NotificationModel.fromJson(Map<String, dynamic>.from(e)))
                  .toList();
        });

        return Right(notifications);
      } catch (e) {
        return Left(DbLoadFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
