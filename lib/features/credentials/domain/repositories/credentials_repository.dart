import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/credentials_model.dart';

abstract class CredentialsRepository {
  Future<Either<Failure, bool>> signInWithCredentials(
      CredentialsModel credentials);
  Future<Either<Failure, bool>> signUpWithCredentials(
      CredentialsModel credentials);
}
