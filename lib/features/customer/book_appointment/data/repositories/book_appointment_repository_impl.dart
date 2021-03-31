import 'package:elaj/core/error/exceptions.dart';
import 'package:elaj/core/firebase/firebase.dart';
import 'package:elaj/core/network/network_info.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/core/util/customer_check_singleton.dart';
import 'package:elaj/features/customer/book_appointment/domain/entities/booking.dart';
import 'package:elaj/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:elaj/features/customer/book_appointment/domain/repositories/book_appointment_repository.dart';
import 'package:elaj/features/doctor/availability/domain/entities/availability.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

        String appointmentID =
            "${booking.categoryID}_${booking.doctorId}_${customerID}_${FirebaseInit.dbRef.push().key}";

        await FirebaseInit.dbRef
            .child(
                "doctor/${booking.doctorId}/slots/${booking.date.millisecondsSinceEpoch.toString()}/${booking.startTime.millisecondsSinceEpoch.toString()}")
            .once()
            .then((snapshot) async {
          if (snapshot.value == "-1") throw InvalidBookingSlotException();

          DateTime currentTime = DateTime.now();
          await NTP.getNtpOffset().then((int ntpOffset) {
            currentTime = currentTime.add(Duration(milliseconds: ntpOffset));
          });
          booking.createdAt = currentTime;

          DateTime reminderTime = booking.startTime.subtract(
              Duration(minutes: Constant.APPOINTMENT_REMINDER_PRE_START_MINS));
          // DateTime endTime =
          //     booking.startTime.add(Duration(minutes: Constant.SESSION_LENGTH));

          await FirebaseInit.dbRef
              .child(
                  "doctor/${booking.doctorId}/slots/${booking.date.millisecondsSinceEpoch.toString()}/${booking.startTime.millisecondsSinceEpoch.toString()}")
              .set("-1");

          await FirebaseInit.dbRef
              .child("appointment/$appointmentID")
              .set(booking.toJson());

          await FirebaseInit.dbRef
              .child(
                  "appointmentTimes/${reminderTime.millisecondsSinceEpoch.toString()}/$appointmentID")
              .set("reminder");

          await FirebaseInit.dbRef
              .child(
                  "appointmentTimes/${booking.startTime.millisecondsSinceEpoch.toString()}/$appointmentID")
              .set("start");

          // await FirebaseInit.dbRef
          //     .child(
          //         "appointmentTimes/${endTime.millisecondsSinceEpoch.toString()}/$appointmentID")
          //     .set("end");
        });

        return Right(true);
      } catch (e) {
        print(e.toString());
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

          if (snapshot.value != null) {
            snapshot.value.forEach((date, slots) {
              DateTime slotDate =
                  DateTime.fromMillisecondsSinceEpoch(int.parse(date));

              if (!slotDate.isBefore(currentDate)) {
                List<String> slotStartTimes =
                    Map<String, String>.from(slots).keys.toList();
                slotStartTimes.sort();

                int index = slotDate.difference(currentDate).inDays;

                availability.availableDays[index].slots = List();

                slotStartTimes.forEach((start) {
                  if (Map<String, String>.from(slots)[start] != "-1") {
                    DateTime startTime =
                        DateTime.fromMillisecondsSinceEpoch(int.parse(start));
                    DateTime endTime = startTime
                        .add(Duration(minutes: Constant.SESSION_LENGTH));
                    DateTime slotTime = DateTime(slotDate.year, slotDate.month,
                        slotDate.day, startTime.hour, startTime.minute);

                    if (slotTime.isAfter(currentTime)) {
                      availability.availableDays[index].slots.add(DaySlot(
                        start: startTime,
                        end: endTime,
                      ));
                    }
                  }
                });
              }
            });
          }
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
        print(e.toString());
        return Left(ProcessFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> checkUser() async {
    if (networkInfo.isConnected != null) {
      try {
        CustomerCheckSingleton customerCheckSingleton =
            new CustomerCheckSingleton();
        if (!customerCheckSingleton.isCustLoggedIn)
          throw UnauthorizedUserException();

        FirebaseUser user = await FirebaseInit.auth.currentUser();
        if (user == null) throw UnauthorizedUserException();

        customerCheckSingleton.isCustLoggedIn = true;

        return Right(true);
      } on UnauthorizedUserException {
        return Left(UnauthorizedUserFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
