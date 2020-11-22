import 'package:emp_recog_plat/core/firebase/firebase.dart';
import 'package:emp_recog_plat/core/network/network_info.dart';
import 'package:emp_recog_plat/features/emp_dashboard/data/models/emp_model.dart';
import 'package:emp_recog_plat/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:emp_recog_plat/features/emp_dashboard/domain/repositories/emp_search_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeSearchRepositoryImpl extends EmployeeSearchRepository {
  final NetworkInfo networkInfo;
  final SharedPreferences sharedPreferences;

  EmployeeSearchRepositoryImpl({this.sharedPreferences, this.networkInfo});

  @override
  Future<Either<Failure, List<EmployeeModel>>> getQueriedEmployees(
      String query) async {
    if (await networkInfo.isConnected) {
      try {
        List<String> exployeeIDs = [];
        List<EmployeeModel> queriedEmployees = [];

        await FirebaseInit.dbRef
            .child("employee")
            .orderByChild("name")
            .startAt(query.toLowerCase())
            .endAt(query.toLowerCase() + "\uf8ff")
            .once()
            .then((lowerSnapshot) async {
          if (lowerSnapshot.value != null) {
            Map<String, dynamic>.from(lowerSnapshot.value)
                .forEach((empID, employeeVal) {
              EmployeeModel employee = EmployeeModel.fromJson(
                  Map<String, dynamic>.from(employeeVal));
              employee.uid = empID;
              if (!exployeeIDs.contains(employee.id))
                queriedEmployees.add(employee);
            });
          }
        });

        return Right(queriedEmployees);
      } catch (e) {
        print(e.toString());
        return Left(DbLoadFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
