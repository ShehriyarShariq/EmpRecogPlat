import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:emp_recog_plat/core/error/failures.dart';
import 'package:emp_recog_plat/features/emp_dashboard/data/models/emp_model.dart';

abstract class EmployeeProfileRepository {
  Future<Either<Failure, EmployeeModel>> getEmployeeProfile({String id});
  Future<Either<Failure, bool>> logOutEmployee();
  Future<Either<Failure, Map<String, String>>> cheerForEmployee(
      {String empID, String traitID});
  Future<void> cacheRank(String rank);
  Future<void> cacheTypeCheer(String type, String cheer);
  String getCachedRank();
  String getCachedTypeCheersCount(String type);
  Future<Either<Failure, String>> updateEmployeeAbout({String aboutTxt});
  Future<Either<Failure, String>> uploadEmployeeImage({File imageFile});
}
