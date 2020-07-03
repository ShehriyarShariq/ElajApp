import 'package:elaj/core/error/exceptions.dart';
import 'package:elaj/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:elaj/core/firebase/firebase.dart';
import 'package:elaj/core/network/network_info.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/features/common/appointment_session/domain/entities/review.dart';
import 'package:elaj/features/customer/doctor_profile_customer_view/domain/repositories/doctor_profile_customer_view_repository.dart';
import 'package:elaj/features/doctor/complete_profile/domain/entities/complete_doctor.dart';

class DoctorProfileCustomerViewRepositoryImpl
    extends DoctorProfileCustomerViewRepository {
  final NetworkInfo networkInfo;

  DoctorProfileCustomerViewRepositoryImpl({this.networkInfo});

  @override
  Future<Either<Failure, CompleteDoctor>> getDoctorProfile(
      String doctorID) async {
    if (networkInfo.isConnected != null) {
      try {
        CompleteDoctor completeDoctor;

        await FirebaseInit.dbRef
            .child("doctor/" + doctorID + "/details")
            .once()
            .then((snapshot) {
          if (snapshot.value == null) throw NoResultException();

          completeDoctor = CompleteDoctor.fromJson(snapshot.value);
        });

        return Right(completeDoctor);
      } on NoResultException {
        return Left(NoResultFailure());
      } catch (e) {
        return Left(DbLoadFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Review>>> getDoctorReviews(
      String lastFetchedReviewID, String categoryID, String doctorID) async {
    if (networkInfo.isConnected != null) {
      try {
        List<Review> reviews = new List();

        await FirebaseInit.dbRef
            .child("category_doctor_review/$categoryID/$doctorID")
            .startAt(null, key: lastFetchedReviewID)
            .limitToFirst(Constant.DOCTOR_REVIEWS_LOAD_LIMIT + 1)
            .once()
            .then((snapshot) async {
          if (snapshot.value != null)
            snapshot.value.map((id, review) async {
              review['id'] = id;
              String customerID = review['appointmentID'].split("_")[2];
              String customerName = "Anonymous";
              await FirebaseInit.dbRef
                  .child("customer/$customerID/details/basic/name")
                  .once()
                  .then((snapshot) {
                if (snapshot.value != null) customerName = snapshot.value;
              });
              review['customerName'] = customerName;

              reviews.add(Review.fromJson(review));
            });
        });

        return Right(reviews);
      } catch (e) {
        return Left(DbLoadFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
