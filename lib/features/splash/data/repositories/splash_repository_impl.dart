import 'package:dartz/dartz.dart';
import 'package:emp_recog_plat/core/error/failures.dart';
import 'package:emp_recog_plat/core/firebase/firebase.dart';
import 'package:emp_recog_plat/core/network/network_info.dart';
import 'package:emp_recog_plat/features/splash/domain/repositories/splash_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashRepositoryImpl extends SplashRepository {
  final NetworkInfo networkInfo;

  SplashRepositoryImpl({this.networkInfo});

  @override
  Future<Either<Failure, Map<String, bool>>> checkCurrentUser() async {
    if (networkInfo.isConnected != null) {
      try {
        User currentUser = FirebaseInit.auth.currentUser;
        if (currentUser == null) return Left(AuthFailure());

        print("WTF BRO");

        bool isEmp = await FirebaseInit.dbRef
            .child("employee/${currentUser.uid}")
            .once()
            .then((snapshot) => snapshot.value != null);

        await Future.delayed(Duration(seconds: 1));

        return Right({
          'isSignedIn': true,
          'isEmp': isEmp,
        });
      } catch (e) {
        return Left(AuthFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
