part of 'doctor_profile_customer_view_bloc.dart';

abstract class DoctorProfileCustomerViewState extends Equatable {
  const DoctorProfileCustomerViewState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class Initial extends DoctorProfileCustomerViewState {}

class Loading extends DoctorProfileCustomerViewState {}

class Loaded extends DoctorProfileCustomerViewState {
  final CompleteDoctor completeDoctor;

  Loaded({this.completeDoctor}) : super([completeDoctor]);
}

class LoadingReviews extends DoctorProfileCustomerViewState {}

class LoadedReviews extends DoctorProfileCustomerViewState {
  final List<Review> reviews;

  LoadedReviews({this.reviews}) : super([reviews]);
}

class Error extends DoctorProfileCustomerViewState {}

class ReviewsLoadError extends DoctorProfileCustomerViewState {}
