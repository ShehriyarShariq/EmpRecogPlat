import 'package:dartz/dartz.dart';
import 'package:emp_recog_plat/core/error/failures.dart';

abstract class SplashRepository {
  Future<Either<Failure, Map<String, bool>>> checkCurrentUser();
  Future<bool> getIsNewUser();
  Future<void> setIsNewUser();
}
