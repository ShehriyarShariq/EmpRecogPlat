import 'package:dartz/dartz.dart';
import 'package:emp_recog_plat/core/error/failures.dart';

abstract class EmployeeHomeRepository {
  Future<Either<Failure, String>> getUserRank();
}