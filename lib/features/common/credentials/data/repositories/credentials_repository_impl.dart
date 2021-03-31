import 'package:elaj/core/entities/user_cred.dart';
import 'package:elaj/core/error/exceptions.dart';
import 'package:elaj/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:elaj/core/firebase/firebase.dart';
import 'package:elaj/core/network/network_info.dart';
import 'package:elaj/features/common/credentials/domain/repositories/credentials_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

class CredentialsRepositoryImpl extends CredentialsRepository {
  final NetworkInfo networkInfo;

  CredentialsRepositoryImpl({@required this.networkInfo});

  @override
  Future<Either<Failure, Map<String, bool>>> signUpUserWithCredentials(
      UserCred userCred) async {
    if (networkInfo.isConnected != null) {
      try {
        AuthResult result = await FirebaseInit.auth
            .createUserWithEmailAndPassword(
                email: userCred.email, password: userCred.password);

        FirebaseUser user = result.user;

        UserUpdateInfo userUpdateInfo = UserUpdateInfo();
        userUpdateInfo.displayName =
            userCred.firstName.trim() + ' ' + userCred.lastName.trim();

        await user.updateProfile(userUpdateInfo);

        Map<String, String> dbMap = Map();
        dbMap["name"] =
            userCred.firstName.trim() + ' ' + userCred.lastName.trim();
        dbMap["email"] = userCred.email.trim();
        dbMap["phoneNum"] = userCred.phoneNum.trim();
        dbMap["gender"] = userCred.gender;

        await FirebaseInit.dbRef
            .child((userCred.isCustomer ? "customer/" : "doctor/") +
                user.uid +
                "/details/basic")
            .set(dbMap);

        if (userCred.signUpReferral != "") {
          await FirebaseInit.dbRef
              .child("referralCodeToUser/" +
                  (userCred.isCustomer ? "customer/" : "doctor/") +
                  userCred.signUpReferral.trim())
              .once()
              .then((snapshot) async {
            if (snapshot.value != null) {
              await FirebaseInit.dbRef
                  .child((userCred.isCustomer ? "customer/" : "doctor/") +
                      user.uid +
                      "/signUpReferral")
                  .set(userCred.signUpReferral.trim());
            } else {
              throw InvalidReferralCodeException();
            }
          });
        }

        await FirebaseInit.fcm.subscribeToTopic(user.uid);

        return Right(
            {'isCust': userCred.isCustomer, 'isCompleteDoctor': false});
      } on InvalidReferralCodeException {
        return Left(InvalidReferralCodeFailure());
      } catch (e) {
        return Left(AuthFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Map<String, bool>>> signInUserWithCredentials(
      UserCred userCred) async {
    if (networkInfo.isConnected != null) {
      try {
        AuthResult result = await FirebaseInit.auth.signInWithEmailAndPassword(
            email: userCred.email, password: userCred.password);
        FirebaseUser user = result.user;

        bool isCust = true;

        // await user.getIdToken(refresh: true).then((idToken) {
        //   print(idToken.claims);
        //   if (idToken.claims.containsKey('customer')) {
        //     isCust = true;
        //   } else if (idToken.claims.containsKey('doctor')) {
        //     isCust = false;
        //   }
        // });
        // if (isCust == null) throw Exception();

        Map<String, bool> map = Map();
        if (!isCust) {
          await FirebaseInit.dbRef
              .child("doctor/" + user.uid + "/details/pmdcNum")
              .once()
              .then((snapshot) {
            if (snapshot.value == null) {
              map = {'isCust': false, 'isCompleteDoctor': false};
            } else {
              map = {'isCust': false, 'isCompleteDoctor': true};
            }
          });

          return Right(map);
        } else {
          return Right({'isCust': isCust});
        }
      } catch (e) {
        return Left(AuthFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
