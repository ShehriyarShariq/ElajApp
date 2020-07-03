import 'package:dartz/dartz.dart';
import 'package:elaj/core/error/failures.dart';
import 'package:elaj/features/common/all_appointments/domain/entities/basic_appointment.dart';

abstract class AppointmentDetailsRepository {
  Future<Either<Failure, Map<String, dynamic>>> checkCancellationStatus(
      String appointmentID, int startTime);
  Future<Either<Failure, bool>> cancelAppointment(
      String appointmentID, bool withPenalty);
  Future<Either<Failure, BasicAppointment>> getAppointmentDetails(
      String appointmentID);
  Future<Either<Failure, bool>> checkJoinSessionStatus(num startTime);
}
