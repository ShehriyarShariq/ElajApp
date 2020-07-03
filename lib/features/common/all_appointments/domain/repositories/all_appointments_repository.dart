import 'package:dartz/dartz.dart';
import 'package:elaj/core/error/failures.dart';
import 'package:elaj/features/common/all_appointments/domain/entities/basic_appointment.dart';

abstract class AllAppointmentsRepository {
  Future<Either<Failure, List<BasicAppointment>>> getCurrentAppointments();
  Future<Either<Failure, List<BasicAppointment>>> getPastAppointments();
}
