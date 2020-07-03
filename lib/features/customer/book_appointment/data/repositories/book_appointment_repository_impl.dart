import 'package:elaj/core/error/exceptions.dart';
import 'package:elaj/core/firebase/firebase.dart';
import 'package:elaj/core/network/network_info.dart';
import 'package:elaj/features/customer/book_appointment/domain/entities/booking.dart';
import 'package:elaj/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:elaj/features/customer/book_appointment/domain/repositories/book_appointment_repository.dart';
import 'package:elaj/features/doctor/availability/domain/entities/availability.dart';
import 'package:ntp/ntp.dart';
import 'package:random_string/random_string.dart';

class BookAppointmentRepositoryImpl extends BookAppointmentRepository {
  final NetworkInfo networkInfo;

  BookAppointmentRepositoryImpl({this.networkInfo});

  @override
  Future<Either<Failure, bool>> bookCustomerAppointment(Booking booking) async {
    if (networkInfo.isConnected != null) {
      try {
        String customerID =
            await FirebaseInit.auth.currentUser().then((user) => user.uid);

        String appointmentID = booking.categoryID +
            "_" +
            booking.doctorId +
            "_" +
            customerID +
            "_" +
            FirebaseInit.dbRef.push().key;

        await FirebaseInit.dbRef
            .child(
                "doctor/${booking.doctorId}/slots/${booking.date.millisecondsSinceEpoch.toString()}/${booking.startTime.millisecondsSinceEpoch.toString()}")
            .once()
            .then((snapshot) async {
          if (snapshot.value == -1) throw InvalidBookingSlotException();

          DateTime currentTime = DateTime.now();
          await NTP.getNtpOffset().then((int ntpOffset) {
            currentTime = currentTime.add(Duration(milliseconds: ntpOffset));
          });
          booking.createdAt = currentTime;

          await FirebaseInit.dbRef
              .child(
                  "doctor/${booking.doctorId}/slots/${booking.date.millisecondsSinceEpoch.toString()}/${booking.startTime.millisecondsSinceEpoch.toString()}")
              .set(-1);

          await FirebaseInit.dbRef
              .child("appointment/$appointmentID")
              .set(booking.toJson());
        });

        return Right(true);
      } catch (e) {
        return Left(ProcessFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Availability>> getDoctorTimings(
      String doctorID) async {
    if (networkInfo.isConnected != null) {
      try {
        Availability availability = Availability();
        availability.availableDays = List();

        await FirebaseInit.dbRef
            .child("doctor/$doctorID/slots")
            .once()
            .then((snapshot) async {
          DateTime currentTime = DateTime.now();
          await NTP.getNtpOffset().then((int ntpOffset) {
            currentTime = currentTime.add(Duration(milliseconds: ntpOffset));
          });
          DateTime currentDate =
              DateTime(currentTime.year, currentTime.month, currentTime.day);

          for (int i = 0; i < 7; i++) {
            availability.availableDays
                .add(AvailableDay(date: currentDate.add(Duration(days: i))));
          }

          if (snapshot.value != null)
            snapshot.value.forEach((date, slots) {
              DateTime slotDate =
                  DateTime.fromMillisecondsSinceEpoch(int.parse(date));

              if (!slotDate.isBefore(currentDate)) {
                int index = currentDate.difference(slotDate).inDays;

                availability.availableDays[index].slots = List();

                slots.forEach((start, end) {
                  DateTime startTime =
                      DateTime.fromMillisecondsSinceEpoch(int.parse(start));
                  DateTime slotTime = DateTime(slotDate.year, slotDate.month,
                      slotDate.day, startTime.hour, startTime.minute);

                  if (slotTime.isAfter(currentTime)) {
                    availability.availableDays[index].slots.add(DaySlot(
                      start: startTime,
                      end: DateTime.fromMillisecondsSinceEpoch(end),
                    ));
                  }
                });
              }
            });
        });
        return Right(availability);
      } catch (e) {
        print(e.toString());
        return Left(DbLoadFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> checkPaymentStatus(int startTime) async {
    if (networkInfo.isConnected != null) {
      try {
        DateTime currentTime = DateTime.now();
        await NTP.getNtpOffset().then((int ntpOffset) {
          currentTime = currentTime.add(Duration(milliseconds: ntpOffset));
        });
        DateTime start = DateTime.fromMillisecondsSinceEpoch(startTime);
        start = start.subtract(Duration(hours: 1));

        return Right(!currentTime
            .isBefore(start)); // True - Pay Right Now, False - Can Pay Later
      } catch (e) {
        return Left(ProcessFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
