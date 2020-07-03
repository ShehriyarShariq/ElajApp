import 'package:elaj/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/core/util/params.dart';
import 'package:elaj/features/doctor/complete_profile/domain/repositories/complete_profile_repository.dart';

class SaveCompleteProfile implements UseCase<bool, CompleteProfileParams> {
  CompleteProfileRepository repository;

  SaveCompleteProfile(this.repository);

  @override
  Future<Either<Failure, bool>> call(CompleteProfileParams params) async {
    return await repository.saveCompleteProfile(params.completeDoctor);
  }
}
