import 'package:dartz/dartz.dart';
import 'package:emp_recog_plat/core/error/failures.dart';
import 'package:emp_recog_plat/features/emp_dashboard/data/models/emp_model.dart';

abstract class EmployeeProfileRepository {
  Future<Either<Failure, EmployeeModel>> getEmployeeProfile({String id});
}
