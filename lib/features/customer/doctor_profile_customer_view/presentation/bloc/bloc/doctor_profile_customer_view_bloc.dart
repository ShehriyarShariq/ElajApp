import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:elaj/core/util/params.dart';
import 'package:elaj/features/common/appointment_session/domain/entities/review.dart';
import 'package:elaj/features/customer/doctor_profile_customer_view/domain/usecases/get_doctor_profile.dart';
import 'package:elaj/features/customer/doctor_profile_customer_view/domain/usecases/get_doctor_reviews.dart';
import 'package:elaj/features/doctor/complete_profile/domain/entities/complete_doctor.dart';
import 'package:equatable/equatable.dart';

part 'doctor_profile_customer_view_event.dart';
part 'doctor_profile_customer_view_state.dart';

class DoctorProfileCustomerViewBloc extends Bloc<DoctorProfileCustomerViewEvent,
    DoctorProfileCustomerViewState> {
  GetDoctorProfile getDoctorProfile;
  GetDoctorReviews getDoctorReviews;

  DoctorProfileCustomerViewBloc(
      {GetDoctorProfile doctorProfile, GetDoctorReviews doctorReviews})
      : assert(doctorProfile != null),
        assert(doctorReviews != null),
        getDoctorProfile = doctorProfile,
        getDoctorReviews = doctorReviews;
  @override
  DoctorProfileCustomerViewState get initialState => Initial();

  @override
  Stream<DoctorProfileCustomerViewState> mapEventToState(
    DoctorProfileCustomerViewEvent event,
  ) async* {
    if (event is LoadDoctorProfileEvent) {
      yield Loading();
      final failureOrCompleteDoctor =
          await getDoctorProfile(DoctorProfileParams(doctorID: event.doctorID));
      yield failureOrCompleteDoctor.fold(
          (failure) => Error(), (doctor) => Loaded(completeDoctor: doctor));
    } else if (event is LoadDoctorReviewsEvent) {
      yield LoadingReviews();
      final failureOrReviews = await getDoctorReviews(DoctorReviewsParams(
          lastFetchedReviewID: event.lastFetchedReviewID,
          categoryID: event.categoryID,
          doctorID: event.doctorID));
      yield failureOrReviews.fold((failure) => ReviewsLoadError(),
          (reviews) => LoadedReviews(reviews: reviews));
    }
  }
}
