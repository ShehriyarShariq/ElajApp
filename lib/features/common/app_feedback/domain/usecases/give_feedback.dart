import 'package:elaj/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/core/util/params.dart';
import 'package:elaj/features/common/app_feedback/domain/repositories/app_feedback_repository.dart';

class GiveFeedback implements UseCase<bool, AppFeedbackParams> {
  final AppFeedbackRepository repository;

  GiveFeedback(this.repository);

  @override
  Future<Either<Failure, bool>> call(params) async {
    return await repository.giveFeedback(params.title, params.desc);
  }
}
