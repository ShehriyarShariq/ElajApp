part of 'home_customer_bloc.dart';

abstract class HomeCustomerState extends Equatable {
  const HomeCustomerState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class Initial extends HomeCustomerState {}

class LoadingCategories extends HomeCustomerState {}

class LoadedCategories extends HomeCustomerState {
  final List<Category> categories;

  LoadedCategories({this.categories}) : super([categories]);
}

class LoadingRecords extends HomeCustomerState {}

class LoadedRecords extends HomeCustomerState {
  final List<MedicalRecord> medicalRecords;

  LoadedRecords({this.medicalRecords}) : super([medicalRecords]);
}

class SearchedCategories extends HomeCustomerState {
  final List<Category> queriedCategories;

  SearchedCategories({this.queriedCategories}) : super([queriedCategories]);
}

class ErrorCategories extends HomeCustomerState {}

class ErrorMedicalRecords extends HomeCustomerState {}

class ErrorUserNotLoggedIn extends HomeCustomerState {}

class LoggingOut extends HomeCustomerState {}

class LogOut extends HomeCustomerState {}

class LogOutError extends HomeCustomerState {}
