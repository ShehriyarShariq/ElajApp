import 'package:elaj/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/core/util/params.dart';
import 'package:elaj/features/customer/book_appointment/domain/repositories/book_appointment_repository.dart';
import 'package:elaj/features/doctor/availability/domain/entities/availability.dart';

class GetDoctorTimings implements UseCase<Availability, BookingParams> {
  BookAppointmentRepository repository;

  GetDoctorTimings(this.repository);

  @override
  Future<Either<Failure, Availability>> call(BookingParams params) async {
    return await repository.getDoctorTimings(params.doctorID);
  }
}
