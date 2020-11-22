import 'dart:io';

import 'package:emp_recog_plat/core/firebase/firebase.dart';
import 'package:emp_recog_plat/core/network/network_info.dart';
import 'package:emp_recog_plat/core/util/constants.dart';
import 'package:emp_recog_plat/features/emp_dashboard/data/models/emp_model.dart';
import 'package:emp_recog_plat/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:emp_recog_plat/features/emp_dashboard/domain/repositories/emp_profile_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ntp/ntp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeProfileRepositoryImpl extends EmployeeProfileRepository {
  final NetworkInfo networkInfo;
  final SharedPreferences sharedPreferences;

  EmployeeProfileRepositoryImpl({this.sharedPreferences, this.networkInfo});

  @override
  Future<Either<Failure, EmployeeModel>> getEmployeeProfile({String id}) async {
    if (await networkInfo.isConnected) {
      try {
        String empID = id;
        if (id == null) {
          empID = FirebaseInit.auth.currentUser.uid;
        }

        EmployeeModel employee = new EmployeeModel.fromJson(await FirebaseInit
            .dbRef
            .child("employee/$empID")
            .once()
            .then((snapshot) {
          Map<String, dynamic> empMap =
              Map<String, dynamic>.from(snapshot.value);
          empMap.addAll({"key": empID});
          return empMap;
        }));

        Map<String, dynamic> employeeCheers = await FirebaseInit.dbRef
            .child("monthly_temp/employee_achievements/employee_cheers/$empID")
            .once()
            .then((snapshot) => snapshot.value == null
                ? {}
                : Map<String, dynamic>.from(snapshot.value));

        employee.badges = await FirebaseInit.dbRef
            .child("monthly_temp/employee_achievements/badges/$empID")
            .once()
            .then((snapshot) => snapshot.value == null
                ? []
                : Map<String, String>.from(snapshot.value).values.toList());

        employee.totalCheers = employeeCheers.containsKey('count')
            ? employeeCheers['count'].toString()
            : "0";
        employee.traitCheers = {};

        if (employeeCheers['traits'] != null)
          Map<String, dynamic>.from(employeeCheers['traits'])
              .entries
              .forEach((e) => employee.traitCheers[e.key] = e.value.toString());

        employee.rank = await FirebaseInit.dbRef
            .child("monthly_temp/ranking/global/$empID")
            .once()
            .then((snapshot) => snapshot.value != null
                ? (snapshot.value + 1).toString()
                : "N/A");

        if (id != null) {
          Map<String, String> alreadyVoted = await FirebaseInit.dbRef
              .child(
                  "monthly_temp/employee_votes/${FirebaseInit.auth.currentUser.uid}/$id")
              .once()
              .then((snapshot) => snapshot.value != null
                  ? Map<String, String>.from(snapshot.value)
                  : {});
          employee.alreadyVoted = alreadyVoted;
        }

        if (id == null) {
          await sharedPreferences.setString("id", employee.id);
          await sharedPreferences.setString(
              "designation", employee.designation ?? "");
          await sharedPreferences.setString("about", employee.about ?? "");
          await sharedPreferences.setStringList("badges", employee.badges);
          await sharedPreferences.setString(
              "category_global", employee.totalCheers);
          await Future.forEach(employee.traitCheers.entries, (trait) async {
            await sharedPreferences.setString(
                "category_${(trait as MapEntry<String, String>).key}",
                (trait as MapEntry<String, String>).value);
          });
        }

        return Right(employee);
      } catch (e) {
        print(e.toString());
        return Left(DbLoadFailure());
      }
    } else {
      if (sharedPreferences.containsKey("id")) {
        EmployeeModel employee = new EmployeeModel(
            id: sharedPreferences.getString("id"),
            name: FirebaseInit.auth.currentUser.displayName,
            imageURL: FirebaseInit.auth.currentUser.photoURL,
            designation: sharedPreferences.getString("designation"),
            about: sharedPreferences.getString("about"),
            rank: sharedPreferences.getString("rank"),
            totalCheers: sharedPreferences.getString("category_global"),
            badges: sharedPreferences.getStringList("badges"),
            traitCheers: {});

        Constant.TRAIT_LABELS.keys.forEach((trait) {
          if (sharedPreferences.containsKey("category_$trait"))
            employee.traitCheers[trait] =
                sharedPreferences.getString("category_$trait");
        });

        return Right(employee);
      } else {
        return Left(NetworkFailure());
      }
    }
  }

  @override
  Future<Either<Failure, bool>> logOutEmployee() async {
    if (await networkInfo.isConnected) {
      try {
        try {
          await FirebaseInit.fcm
              .unsubscribeFromTopic(FirebaseInit.auth.currentUser.uid);
        } catch (e) {}

        try {
          await FirebaseInit.fcm.unsubscribeFromTopic("scheduled_notifs");
        } catch (e) {}

        await FirebaseInit.auth.signOut();
        await Future.delayed(Duration(milliseconds: 500));

        return Right(true);
      } catch (e) {
        return Left(AuthFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Map<String, String>>> cheerForEmployee(
      {String empID, String traitID}) async {
    if (await networkInfo.isConnected) {
      try {
        String updatedTraitCheerCount, updatedTotalCheerCount, updatedRank;

        await FirebaseInit.dbRef
            .child(
                "monthly_temp/employee_achievements/employee_cheers/$empID/traits/$traitID")
            .runTransaction((mutableData) async {
          mutableData.value = (mutableData.value ?? 0) + 1;
          return mutableData;
        }, timeout: Duration(seconds: 15)).then((value) async {
          updatedTraitCheerCount = value.dataSnapshot.value.toString();
          await FirebaseInit.dbRef
              .child(
                  "monthly_temp/employee_achievements/employee_cheers/$empID/count")
              .runTransaction((mutableData) async {
            mutableData.value = (mutableData.value ?? 0) + 1;
            return mutableData;
          }, timeout: Duration(seconds: 15)).then((value) async {
            updatedTotalCheerCount = value.dataSnapshot.value.toString();
            FirebaseInit.dbRef
                .child(
                    "monthly_temp/employee_votes/${FirebaseInit.auth.currentUser.uid}/$empID/$traitID")
                .set("Trait ID")
                .then((value) async {
              String currentUserName =
                  FirebaseInit.auth.currentUser.displayName.isEmpty
                      ? "N/A"
                      : FirebaseInit.auth.currentUser.displayName;
              String otherEmpName = await FirebaseInit.dbRef
                  .child("employee/$empID/name")
                  .once()
                  .then((value) => value.value);

              FirebaseInit.dbRef.child("activity_log").push().set({
                'timestamp': (await NTP.now()).millisecondsSinceEpoch,
                'message':
                    "$currentUserName cheered for $otherEmpName for ${Constant.TRAIT_LABELS[traitID]}",
                'userID': FirebaseInit.auth.currentUser.uid
              });
            });
          });
        });

        return Right({
          "traitID": traitID,
          "updatedCount": updatedTraitCheerCount,
          "updatedTotalCount": updatedTotalCheerCount,
        });
      } catch (e) {
        print(e.toString());
        return Left(ProcessFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, String>> updateEmployeeAbout({String aboutTxt}) async {
    if (await networkInfo.isConnected) {
      try {
        await FirebaseInit.dbRef
            .child("employee/${FirebaseInit.auth.currentUser.uid}/about")
            .set(aboutTxt);

        return Right(aboutTxt);
      } catch (e) {
        return Left(ProcessFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, String>> uploadEmployeeImage({File imageFile}) async {
    if (await networkInfo.isConnected) {
      try {
        StorageUploadTask imageUploadTask = FirebaseInit.storageRef
            .child(
                "${FirebaseInit.auth.currentUser.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg")
            .putFile(imageFile);
        StorageTaskSnapshot imageDownloadUrl = await imageUploadTask.onComplete;
        String url = await imageDownloadUrl.ref.getDownloadURL();

        await FirebaseInit.dbRef
            .child("employee/${FirebaseInit.auth.currentUser.uid}/imageURL")
            .set(url);

        await FirebaseInit.auth.currentUser.updateProfile(photoURL: url);

        return Right(url);
      } catch (e) {
        return Left(ProcessFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<void> cacheRank(String rank) async {
    sharedPreferences.setString("rank", rank);
  }

  @override
  String getCachedRank() {
    return sharedPreferences.getString("rank");
  }

  @override
  Future<void> cacheTypeCheer(String type, String cheer) async {
    sharedPreferences.setString("category_$type", cheer);
  }

  @override
  String getCachedTypeCheersCount(String type) {
    return sharedPreferences.getString("category_$type");
  }
}
