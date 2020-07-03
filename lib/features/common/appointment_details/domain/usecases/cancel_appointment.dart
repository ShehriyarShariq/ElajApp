import 'package:elaj/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/core/util/params.dart';
import 'package:elaj/features/common/appointment_details/domain/repositories/appointment_details_repository.dart';

class CancelAppointment implements UseCase<bool, AppointmentParams> {
  AppointmentDetailsRepository repository;

  CancelAppointment(this.repository);

  @override
  Future<Either<Failure, bool>> call(AppointmentParams params) async {
    return await repository.cancelAppointment(
        params.appointmentID, params.withPenalty);
  }
}
