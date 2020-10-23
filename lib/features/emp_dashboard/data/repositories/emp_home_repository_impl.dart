import 'package:dartz/dartz.dart';
import 'package:emp_recog_plat/core/error/failures.dart';
import 'package:emp_recog_plat/core/firebase/firebase.dart';
import 'package:emp_recog_plat/core/network/network_info.dart';
import 'package:emp_recog_plat/features/emp_dashboard/domain/repositories/emp_home_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmployeeHomeRepositoryImpl extends EmployeeHomeRepository {
  final NetworkInfo networkInfo;

  EmployeeHomeRepositoryImpl({this.networkInfo});

  @override
  Future<Either<Failure, String>> getUserRank() async {
    if (networkInfo.isConnected != null) {
      try {
        User currentUser = FirebaseInit.auth.currentUser;

        return Right(await FirebaseInit.dbRef
            .child("ranking/${currentUser.uid}")
            .once()
            .then((snapshot) =>
                snapshot.value != null ? snapshot.value.toString() : "N/A"));
      } catch (e) {
        return Left(DbLoadFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
