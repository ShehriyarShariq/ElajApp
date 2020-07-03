import 'package:elaj/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/core/util/params.dart';
import 'package:elaj/features/common/appointment_session/domain/repositories/appointment_session_repository.dart';

class GiveAppointmentRating implements UseCase<bool, RatingParams> {
  AppointmentSessionRepository repository;

  GiveAppointmentRating(this.repository);

  @override
  Future<Either<Failure, bool>> call(RatingParams params) async {
    return await repository.giveAppointmentRating(params.rating);
  }
}
