part of 'doctor_profile_customer_view_bloc.dart';

abstract class DoctorProfileCustomerViewEvent extends Equatable {
  const DoctorProfileCustomerViewEvent([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class LoadDoctorProfileEvent extends DoctorProfileCustomerViewEvent {
  final String doctorID;

  LoadDoctorProfileEvent({this.doctorID}) : super([doctorID]);
}

class LoadDoctorReviewsEvent extends DoctorProfileCustomerViewEvent {
  final String lastFetchedReviewID, categoryID, doctorID;

  LoadDoctorReviewsEvent(
      {this.lastFetchedReviewID, this.categoryID, this.doctorID})
      : super([lastFetchedReviewID, categoryID, doctorID]);
}
