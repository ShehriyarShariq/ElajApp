import 'package:elaj/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/core/util/params.dart';
import 'package:elaj/features/common/appointment_session/domain/repositories/appointment_session_repository.dart';

class GivePrescription implements UseCase<bool, PrescriptionParams> {
  AppointmentSessionRepository repository;

  GivePrescription(this.repository);

  @override
  Future<Either<Failure, bool>> call(PrescriptionParams params) async {
    return await repository.givePrescription(params.prescription);
  }
}
