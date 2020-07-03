import 'package:dartz/dartz.dart';
import 'package:elaj/core/error/failures.dart';

abstract class SplashRepository {
  Future<Either<Failure, Map<String, bool>>> checkCurrentUser();
}
