import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/firebase/firebase.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/prescription.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/appointment_session_repository.dart';

class AppointmentSessionRepositoryImpl extends AppointmentSessionRepository {
  final NetworkInfo networkInfo;

  AppointmentSessionRepositoryImpl({this.networkInfo});

  @override
  Future<Either<Failure, bool>> giveAppointmentRating(Review rating) async {
    if (networkInfo.isConnected != null) {
      try {
        if (rating.star != null) {
          List<String> ids = rating.appointmentID.split("_");

          await FirebaseInit.dbRef
              .child("category_doctor_review/${ids[1]}/${ids[2]}")
              .push()
              .set(rating.toJson());
        }

        await FirebaseInit.dbRef
            .child("appointment/${rating.appointmentID}/basic/status")
            .set("finishing");

        return Right(true);
      } catch (e) {
        return Left(ProcessFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> givePrescription(
      Prescription prescription) async {
    if (networkInfo.isConnected != null) {
      try {
        await FirebaseInit.dbRef
            .child("appointment/${prescription.appointmentID}/prescription")
            .set(prescription.message);

        await FirebaseInit.dbRef
            .child("appointment/${prescription.appointmentID}/basic/status")
            .set("finishing");

        return Right(true);
      } catch (e) {
        return Left(ProcessFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> acknowledgeEarlyEnd(
      String appointmentID, bool isEnd, bool forCust) async {
    if (networkInfo.isConnected != null) {
      try {
        await FirebaseInit.dbRef
            .child(
                "appointment/$appointmentID/sessionInfo/earlyEndAck/${forCust ? "customer" : "doctor"}")
            .set(isEnd);

        return Right(true);
      } catch (e) {
        return Left(ProcessFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
