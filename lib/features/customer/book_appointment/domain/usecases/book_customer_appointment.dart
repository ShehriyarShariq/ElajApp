import 'package:elaj/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/core/util/params.dart';
import 'package:elaj/features/customer/book_appointment/domain/repositories/book_appointment_repository.dart';

class BookCustomerAppointment implements UseCase<bool, BookingParams> {
  BookAppointmentRepository repository;

  BookCustomerAppointment(this.repository);

  @override
  Future<Either<Failure, bool>> call(BookingParams params) async {
    return await repository.bookCustomerAppointment(params.booking);
  }
}
