import 'package:dartz/dartz.dart';
import 'package:emp_recog_plat/core/error/failures.dart';
import 'package:emp_recog_plat/core/firebase/firebase.dart';
import 'package:emp_recog_plat/core/network/network_info.dart';
import 'package:emp_recog_plat/core/util/constants.dart';
import 'package:emp_recog_plat/features/splash/domain/repositories/splash_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashRepositoryImpl extends SplashRepository {
  final NetworkInfo networkInfo;
  final SharedPreferences sharedPreferences;

  SplashRepositoryImpl({this.sharedPreferences, this.networkInfo});

  @override
  Future<Either<Failure, Map<String, bool>>> checkCurrentUser() async {
    if (await networkInfo.isConnected) {
      try {
        User currentUser = FirebaseInit.auth.currentUser;
        if (currentUser == null) return Left(AuthFailure());

        bool isEmp = await FirebaseInit.dbRef
            .child("employee/${currentUser.uid}")
            .once()
            .then((snapshot) => snapshot.value != null);

        await sharedPreferences.setBool("isEmp", isEmp);

        await Future.delayed(Duration(milliseconds: 500));

        return Right({
          'isSignedIn': true,
          'isEmp': isEmp,
        });
      } catch (e) {
        print(e.toString());
        return Left(AuthFailure());
      }
    } else {
      User currentUser = FirebaseInit.auth.currentUser;
      if (currentUser == null) return Left(AuthFailure());

      return Right({
        'isSignedIn': true,
        'isEmp': sharedPreferences.getBool("isEmp") ?? false,
      });
    }
  }

  @override
  Future<bool> getIsNewUser() {
    return Future.value(
        !sharedPreferences.containsKey(Constant.FIRST_TIME_USER_CHECK_PREF));
  }

  @override
  Future<void> setIsNewUser() {
    return Future.value(
        sharedPreferences.setBool(Constant.FIRST_TIME_USER_CHECK_PREF, true));
  }
}
