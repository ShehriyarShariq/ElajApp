import 'package:dartz/dartz.dart';
import 'package:elaj/core/error/failures.dart';
import 'package:elaj/features/doctor/availability/domain/entities/availability.dart';

abstract class AvailabilityRepository {
  Future<Either<Failure, Availability>> loadAvailableDays();
  Future<Either<Failure, List<int>>> saveAvailableDays(
      Availability availability);
}
