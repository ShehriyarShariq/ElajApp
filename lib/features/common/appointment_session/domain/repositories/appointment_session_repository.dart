import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:elaj/core/error/failures.dart';
import 'package:elaj/features/common/appointment_session/domain/entities/prescription.dart';
import 'package:elaj/features/common/appointment_session/domain/entities/review.dart';
import 'package:firebase_database/firebase_database.dart';

abstract class AppointmentSessionRepository {
  Future<Either<Failure, bool>> giveAppointmentRating(Review rating);
  Future<Either<Failure, bool>> givePrescription(Prescription prescription);
  Future<Either<Failure, bool>> acknowledgeEarlyEnd(
      String appointmentID, bool isEnd, bool forCust);
}
