import 'package:elaj/core/firebase/firebase.dart';
import 'package:elaj/core/network/network_info.dart';
import 'package:elaj/features/common/appointment_session/domain/entities/prescription.dart';
import 'package:elaj/features/common/appointment_session/domain/entities/review.dart';
import 'package:elaj/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:elaj/features/common/appointment_session/domain/repositories/appointment_session_repository.dart';

class AppointmentSessionRepositoryImpl extends AppointmentSessionRepository {
  final NetworkInfo networkInfo;

  AppointmentSessionRepositoryImpl({this.networkInfo});

  @override
  Future<Either<Failure, bool>> giveAppointmentRating(Review rating) async {
    if (networkInfo.isConnected != null) {
      try {
        List<String> ids = rating.appointmentID.split("_");

        await FirebaseInit.dbRef
            .child("category_doctor_review/" + ids[1] + "/" + ids[2])
            .push()
            .set(rating.toJson());

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
            .child(
                "appointment/" + prescription.appointmentID + "/prescription")
            .set(prescription.medicines);

        return Right(true);
      } catch (e) {
        return Left(ProcessFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
