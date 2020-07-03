import 'package:dartz/dartz.dart';
import 'package:elaj/core/error/failures.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/core/util/params.dart';
import 'package:elaj/features/common/all_appointments/domain/entities/basic_appointment.dart';
import 'package:elaj/features/common/all_appointments/domain/repositories/all_appointments_repository.dart';
import 'package:elaj/features/common/appointment_details/domain/repositories/appointment_details_repository.dart';

class GetAppointmentDetails
    implements UseCase<BasicAppointment, AppointmentParams> {
  final AppointmentDetailsRepository repository;

  GetAppointmentDetails(this.repository);

  @override
  Future<Either<Failure, BasicAppointment>> call(
      AppointmentParams params) async {
    return await repository.getAppointmentDetails(params.appointmentID);
  }
}
