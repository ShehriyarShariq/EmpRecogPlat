import 'package:emp_recog_plat/core/firebase/firebase.dart';
import 'package:emp_recog_plat/core/network/network_info.dart';
import 'package:emp_recog_plat/features/credentials/data/models/credentials_model.dart';
import 'package:emp_recog_plat/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:emp_recog_plat/features/credentials/domain/repositories/credentials_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class CredentialsRepositoryImpl extends CredentialsRepository {
  final NetworkInfo networkInfo;

  CredentialsRepositoryImpl({this.networkInfo});

  @override
  Future<Either<Failure, bool>> signInWithCredentials(
      CredentialsModel credentials) async {
    if (await networkInfo.isConnected) {
      try {
        print(FirebaseInit.auth);
        await FirebaseInit.auth.signInWithEmailAndPassword(
            email: credentials.email, password: credentials.password);

        User currentUser = FirebaseInit.auth.currentUser;

        bool isAdmin = (await FirebaseInit.dbRef
            .child("admin/${currentUser.uid}")
            .once()
            .then((snapshot) => snapshot.value != null));

        if (!isAdmin) {
          if (currentUser.emailVerified) {
            await FirebaseInit.fcm.subscribeToTopic(currentUser.uid);
            await FirebaseInit.fcm.subscribeToTopic("scheduled_notifs");

            return Right(false);
          } else {
            await FirebaseInit.auth.signOut();
            return Left(
                AuthFailure(errorMsg: "Please verify your email to continue."));
          }
        }

        return Right(true);
      } on FirebaseAuthException catch (e) {
        return Left(AuthFailure(errorMsg: e.message));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> signUpWithCredentials(
      CredentialsModel credentials) async {
    if (await networkInfo.isConnected) {
      try {
        await FirebaseInit.dbRef
            .child("unregistered_employees/${credentials.empID}")
            .once()
            .then((snapshot) async {
          if (snapshot.value == null)
            return Left(AuthFailure(errorMsg: "Invalid Employee"));

          if (snapshot.value['email'] != credentials.email)
            return Left(AuthFailure(errorMsg: "Invalid Email"));

          await FirebaseInit.auth.createUserWithEmailAndPassword(
              email: credentials.email, password: credentials.password);

          User currentUser = FirebaseInit.auth.currentUser;
          currentUser.updateProfile(displayName: snapshot.value['name']);

          await FirebaseInit.dbRef.child("employee/${currentUser.uid}").set({
            "id": snapshot.key,
            "name": snapshot.value['name'].toString().toLowerCase(),
            "email": snapshot.value['email'],
            "designation": snapshot.value['designation'],
          }).then((value) async {
            await FirebaseInit.dbRef
                .child("unregistered_employees/${snapshot.key}")
                .remove();
          });
        });

        await FirebaseInit.auth.currentUser.sendEmailVerification();

        FirebaseInit.auth.signOut();

        return Right(true);
      } on FirebaseAuthException catch (e) {
        return Left(AuthFailure(errorMsg: e.message));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
