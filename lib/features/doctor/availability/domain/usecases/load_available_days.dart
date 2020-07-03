import 'package:elaj/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/features/doctor/availability/domain/entities/availability.dart';
import 'package:elaj/features/doctor/availability/domain/repositories/availability_repository.dart';

class LoadAvailableDays implements UseCase<Availability, NoParams> {
  AvailabilityRepository repository;

  LoadAvailableDays(this.repository);

  @override
  Future<Either<Failure, Availability>> call(NoParams params) async {
    return await repository.loadAvailableDays();
  }
}
