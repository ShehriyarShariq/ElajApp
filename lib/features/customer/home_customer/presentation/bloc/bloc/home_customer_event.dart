part of 'home_customer_bloc.dart';

abstract class HomeCustomerEvent extends Equatable {
  const HomeCustomerEvent([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class GetAllCategoriesEvent extends HomeCustomerEvent {}

class GetAllMedicalRecordsEvent extends HomeCustomerEvent {}

class SearchFromCategoriesEvent extends HomeCustomerEvent {
  final String searchTerm;
  final List<Category> list;

  SearchFromCategoriesEvent(this.searchTerm, this.list)
      : super([searchTerm, list]);
}

class LogOutEvent extends HomeCustomerEvent {}
