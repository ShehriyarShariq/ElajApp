import 'package:elaj/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/core/util/params.dart';
import 'package:elaj/features/common/appointment_session/domain/repositories/appointment_session_repository.dart';

class AcknowledgeEarlyEnd implements UseCase<bool, AcknowledgementParams> {
  AppointmentSessionRepository repository;

  AcknowledgeEarlyEnd(this.repository);

  @override
  Future<Either<Failure, bool>> call(AcknowledgementParams params) async {
    return await repository.acknowledgeEarlyEnd(
        params.appointmentID, params.isEnd, params.forCust);
  }
}
