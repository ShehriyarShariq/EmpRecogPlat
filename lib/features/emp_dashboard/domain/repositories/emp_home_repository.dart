import 'package:dartz/dartz.dart';
import 'package:emp_recog_plat/core/error/failures.dart';
import 'package:emp_recog_plat/features/emp_dashboard/data/models/emp_model.dart';

abstract class EmployeeHomeRepository {
  Future<Either<Failure, EmployeeModel>> getCurrentUserDetails();
  Future<Either<Failure, Map<String, List<EmployeeModel>>>>
      getFeaturedEmployees();
  Future<void> cacheRank(String rank);
  String getCachedRank();
}
