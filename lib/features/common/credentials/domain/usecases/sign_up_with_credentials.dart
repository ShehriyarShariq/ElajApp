import 'package:dartz/dartz.dart';
import 'package:elaj/core/error/failures.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/core/util/params.dart';
import 'package:elaj/features/common/credentials/domain/repositories/credentials_repository.dart';

class SignUpWithCredentials implements UseCase<Map<String, bool>, AuthParams> {
  final CredentialsRepository repository;

  SignUpWithCredentials(this.repository);

  @override
  Future<Either<Failure, Map<String, bool>>> call(AuthParams params) async {
    return await repository.signUpUserWithCredentials(params.userCred);
  }
}
