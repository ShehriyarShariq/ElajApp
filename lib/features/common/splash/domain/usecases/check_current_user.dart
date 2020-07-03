import 'package:elaj/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/features/common/splash/domain/repositories/splash_repository.dart';

class CheckCurrentUser implements UseCase<Map<String, bool>, NoParams> {
  SplashRepository repository;

  CheckCurrentUser(this.repository);

  @override
  Future<Either<Failure, Map<String, bool>>> call(NoParams params) async {
    return await repository.checkCurrentUser();
  }
}
