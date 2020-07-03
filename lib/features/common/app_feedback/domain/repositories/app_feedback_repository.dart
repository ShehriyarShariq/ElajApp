import 'package:dartz/dartz.dart';
import 'package:elaj/core/error/failures.dart';

abstract class AppFeedbackRepository {
  Future<Either<Failure, bool>> giveFeedback(String title, String desc);
}
