import 'package:elaj/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/features/doctor/complete_profile/domain/repositories/complete_profile_repository.dart';

class LoadInitData implements UseCase<Map<String, dynamic>, NoParams> {
  CompleteProfileRepository repository;

  LoadInitData(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) async {
    return await repository.loadInitData();
  }
}
