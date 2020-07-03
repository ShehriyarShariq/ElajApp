import 'package:dartz/dartz.dart';
import 'package:elaj/core/error/failures.dart';
import 'package:elaj/features/common/appointment_session/domain/entities/review.dart';
import 'package:elaj/features/doctor/complete_profile/domain/entities/complete_doctor.dart';

abstract class DoctorProfileCustomerViewRepository {
  Future<Either<Failure, CompleteDoctor>> getDoctorProfile(String doctorID);
  Future<Either<Failure, List<Review>>> getDoctorReviews(
      String lastFetchedReviewID, String categoryID, String doctorID);
}
