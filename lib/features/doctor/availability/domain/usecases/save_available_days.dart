import 'package:elaj/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/core/util/params.dart';
import 'package:elaj/features/doctor/availability/domain/entities/availability.dart';
import 'package:elaj/features/doctor/availability/domain/repositories/availability_repository.dart';

class SaveAvailableDays implements UseCase<List<int>, AvailabilityParams> {
  AvailabilityRepository repository;

  SaveAvailableDays(this.repository);

  @override
  Future<Either<Failure, List<int>>> call(AvailabilityParams params) async {
    return await repository.saveAvailableDays(params.availability);
  }
}
