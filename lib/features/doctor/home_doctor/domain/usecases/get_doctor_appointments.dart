import 'package:elaj/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/features/common/all_appointments/domain/entities/basic_appointment.dart';
import 'package:elaj/features/doctor/home_doctor/domain/repositories/home_doctor_repository.dart';

class GetDoctorAppointments
    implements UseCase<Map<DateTime, List<BasicAppointment>>, NoParams> {
  HomeDoctorRepository repository;

  GetDoctorAppointments(this.repository);

  @override
  Future<Either<Failure, Map<DateTime, List<BasicAppointment>>>> call(
      NoParams params) async {
    return await repository.getDoctorAppointments();
  }
}
