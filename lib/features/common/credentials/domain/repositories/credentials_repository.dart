import 'package:dartz/dartz.dart';
import 'package:elaj/core/entities/user_cred.dart';
import 'package:elaj/core/error/failures.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class CredentialsRepository {
  Future<Either<Failure, Map<String, bool>>> signInUserWithCredentials(
      UserCred userCred);

  Future<Either<Failure, Map<String, bool>>> signUpUserWithCredentials(
      UserCred userCred);
}
