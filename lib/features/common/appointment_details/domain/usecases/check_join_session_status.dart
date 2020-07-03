import 'package:elaj/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/core/util/params.dart';
import 'package:elaj/features/common/appointment_details/domain/repositories/appointment_details_repository.dart';

class CheckJoinSessionStatus implements UseCase<bool, AppointmentParams> {
  AppointmentDetailsRepository repository;

  CheckJoinSessionStatus(this.repository);

  @override
  Future<Either<Failure, bool>> call(AppointmentParams params) async {
    return await repository.checkJoinSessionStatus(params.startTime);
  }
}
