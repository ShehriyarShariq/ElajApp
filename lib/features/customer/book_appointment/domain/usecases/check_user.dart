import 'package:elaj/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/features/customer/book_appointment/domain/repositories/book_appointment_repository.dart';

class CheckUser implements UseCase<bool, NoParams> {
  BookAppointmentRepository repository;

  CheckUser(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.checkUser();
  }
}
