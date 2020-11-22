import 'package:dartz/dartz.dart';
import 'package:emp_recog_plat/core/error/failures.dart';
import 'package:emp_recog_plat/core/firebase/firebase.dart';
import 'package:emp_recog_plat/core/network/network_info.dart';
import 'package:emp_recog_plat/features/emp_dashboard/data/models/emp_model.dart';
import 'package:emp_recog_plat/features/emp_dashboard/domain/repositories/emp_home_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeHomeRepositoryImpl extends EmployeeHomeRepository {
  final NetworkInfo networkInfo;
  final SharedPreferences sharedPreferences;

  EmployeeHomeRepositoryImpl({this.sharedPreferences, this.networkInfo});

  @override
  Future<Either<Failure, EmployeeModel>> getCurrentUserDetails() async {
    if (await networkInfo.isConnected) {
      try {
        EmployeeModel employee = new EmployeeModel(
          name: FirebaseInit.auth.currentUser.displayName,
          imageURL: FirebaseInit.auth.currentUser.photoURL,
        );

        employee.badges = await FirebaseInit.dbRef
            .child(
                "monthly_temp/employee_achievements/badges/${FirebaseInit.auth.currentUser.uid}")
            .once()
            .then((snapshot) => snapshot.value == null
                ? []
                : Map<String, String>.from(snapshot.value).values.toList());

        await sharedPreferences.setStringList("badges", employee.badges);

        return Right(employee);
      } catch (e) {
        print(e.toString());
        return Left(DbLoadFailure());
      }
    } else {
      EmployeeModel employee = new EmployeeModel(
        name: FirebaseInit.auth.currentUser.displayName,
        imageURL: FirebaseInit.auth.currentUser.photoURL,
        badges: sharedPreferences.getStringList("badges"),
      );

      return Right(employee);
    }
  }

  @override
  Future<Either<Failure, Map<String, List<EmployeeModel>>>>
      getFeaturedEmployees() async {
    if (await networkInfo.isConnected) {
      try {
        Map<String, List<EmployeeModel>> featured = {};

        List<EmployeeModel> globalRankers = [];
        await FirebaseInit.dbRef
            .child("monthly_temp/leaderboard/global")
            .orderByKey()
            .limitToFirst(3)
            .once()
            .then((snapshot) {
          if (snapshot.value != null) {
            List<dynamic>.from(snapshot.value).forEach((employee) {
              globalRankers.add(
                  EmployeeModel.fromJson(Map<String, dynamic>.from(employee)));
            });
          }
        });
        if (globalRankers.isNotEmpty) featured['global'] = globalRankers;

        await FirebaseInit.dbRef
            .child("monthly_temp/leaderboard/traits/teamwork/0")
            .once()
            .then((snapshot) {
          if (snapshot.value != null)
            featured['teamwork'] = [
              EmployeeModel.fromJson(Map<String, dynamic>.from(snapshot.value))
            ];
        });

        await FirebaseInit.dbRef
            .child("monthly_temp/leaderboard/traits/leadership/0")
            .once()
            .then((snapshot) {
          if (snapshot.value != null)
            featured['leadership'] = [
              EmployeeModel.fromJson(Map<String, dynamic>.from(snapshot.value))
            ];
        });

        await FirebaseInit.dbRef
            .child("monthly_temp/leaderboard/traits/communication/0")
            .once()
            .then((snapshot) {
          if (snapshot.value != null)
            featured['communication'] = [
              EmployeeModel.fromJson(Map<String, dynamic>.from(snapshot.value))
            ];
        });

        await FirebaseInit.dbRef
            .child("monthly_temp/leaderboard/traits/attitude/0")
            .once()
            .then((snapshot) {
          if (snapshot.value != null)
            featured['attitude'] = [
              EmployeeModel.fromJson(Map<String, dynamic>.from(snapshot.value))
            ];
        });

        await FirebaseInit.dbRef
            .child("monthly_temp/leaderboard/traits/work_ethic/0")
            .once()
            .then((snapshot) {
          if (snapshot.value != null)
            featured['work_ethic'] = [
              EmployeeModel.fromJson(Map<String, dynamic>.from(snapshot.value))
            ];
        });

        print(featured);

        return Right(featured);
      } catch (e) {
        print(e.toString());
        return Left(DbLoadFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<void> cacheRank(String rank) {
    sharedPreferences.setString("rank", rank);
  }

  @override
  String getCachedRank() {
    return sharedPreferences.getString("rank");
  }
}
