import 'package:elaj/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/core/util/params.dart';
import 'package:elaj/features/customer/book_appointment/domain/repositories/book_appointment_repository.dart';

class CheckPaymentStatus implements UseCase<bool, AppointmentParams> {
  BookAppointmentRepository repository;

  CheckPaymentStatus(this.repository);

  @override
  Future<Either<Failure, bool>> call(AppointmentParams params) async {
    return await repository.checkPaymentStatus(params.startTime);
  }
}
