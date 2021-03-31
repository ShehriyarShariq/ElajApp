import 'package:dartz/dartz.dart';
import 'package:elaj/core/error/failures.dart';
import 'package:elaj/features/customer/book_appointment/domain/entities/booking.dart';
import 'package:elaj/features/doctor/availability/domain/entities/availability.dart';

abstract class BookAppointmentRepository {
  Future<Either<Failure, bool>> bookCustomerAppointment(Booking booking);
  Future<Either<Failure, Availability>> getDoctorTimings(String doctorID);
  Future<Either<Failure, bool>> checkPaymentStatus(int startTime);
  Future<Either<Failure, bool>> checkUser();
}
