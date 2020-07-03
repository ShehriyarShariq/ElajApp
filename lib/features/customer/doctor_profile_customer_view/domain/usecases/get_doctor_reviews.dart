import 'package:dartz/dartz.dart';
import 'package:elaj/core/error/failures.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/core/util/params.dart';
import 'package:elaj/features/common/appointment_session/domain/entities/review.dart';
import 'package:elaj/features/customer/doctor_profile_customer_view/domain/repositories/doctor_profile_customer_view_repository.dart';

class GetDoctorReviews implements UseCase<List<Review>, DoctorReviewsParams> {
  DoctorProfileCustomerViewRepository repository;

  GetDoctorReviews(this.repository);

  @override
  Future<Either<Failure, List<Review>>> call(params) async {
    return await repository.getDoctorReviews(
        params.lastFetchedReviewID, params.categoryID, params.doctorID);
  }
}
