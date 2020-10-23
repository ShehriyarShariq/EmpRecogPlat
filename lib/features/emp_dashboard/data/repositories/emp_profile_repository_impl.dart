import 'package:emp_recog_plat/core/firebase/firebase.dart';
import 'package:emp_recog_plat/core/network/network_info.dart';
import 'package:emp_recog_plat/features/emp_dashboard/data/models/emp_model.dart';
import 'package:emp_recog_plat/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:emp_recog_plat/features/emp_dashboard/domain/repositories/emp_profile_repository.dart';

class EmployeeProfileRepositoryImpl extends EmployeeProfileRepository {
  final NetworkInfo networkInfo;

  EmployeeProfileRepositoryImpl({this.networkInfo});
  
  @override
  Future<Either<Failure, EmployeeModel>> getEmployeeProfile({String id}) async {
    if(networkInfo.isConnected != null) {
      try {        
        String empID = id;
        if(id == null) {
          empID = FirebaseInit.auth.currentUser.uid;
        }

        EmployeeModel employee = new EmployeeModel.fromJson(await FirebaseInit.dbRef.child("employee/$empID").once().then((snapshot) => Map<String, dynamic>.from(snapshot.value)));
      } catch (e) {
        return Left(DbLoadFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

}