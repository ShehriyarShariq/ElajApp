import 'package:elaj/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/core/util/params.dart';
import 'package:elaj/features/common/appointment_details/domain/repositories/appointment_details_repository.dart';

class CheckCancellationStatus
    implements UseCase<Map<String, dynamic>, AppointmentParams> {
  AppointmentDetailsRepository repository;

  CheckCancellationStatus(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(
      AppointmentParams params) async {
    return await repository.checkCancellationStatus(
        params.appointmentID, params.startTime);
  }
}
