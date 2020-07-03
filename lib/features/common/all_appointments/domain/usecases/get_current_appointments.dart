import 'package:dartz/dartz.dart';
import 'package:elaj/core/error/failures.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/core/util/params.dart';
import 'package:elaj/features/common/all_appointments/domain/entities/basic_appointment.dart';
import 'package:elaj/features/common/all_appointments/domain/repositories/all_appointments_repository.dart';

class GetAllCurrentAppointments
    implements UseCase<List<BasicAppointment>, NoParams> {
  final AllAppointmentsRepository repository;

  GetAllCurrentAppointments(this.repository);

  @override
  Future<Either<Failure, List<BasicAppointment>>> call(NoParams params) async {
    return await repository.getCurrentAppointments();
  }
}
