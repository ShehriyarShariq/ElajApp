import 'package:elaj/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/core/util/params.dart';
import 'package:elaj/features/common/credentials/domain/repositories/credentials_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInWithCredentials implements UseCase<Map<String, bool>, AuthParams> {
  final CredentialsRepository repository;

  SignInWithCredentials(this.repository);

  @override
  Future<Either<Failure, Map<String, bool>>> call(AuthParams params) async {
    return await repository.signInUserWithCredentials(params.userCred);
  }
}
