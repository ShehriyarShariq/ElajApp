part of 'categorical_doctors_bloc.dart';

abstract class CategoricalDoctorsEvent extends Equatable {
  const CategoricalDoctorsEvent([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class GetAllCategoricalDoctorsEvent extends CategoricalDoctorsEvent {
  final String lastFetchedDoctorID, categoryID;

  GetAllCategoricalDoctorsEvent({this.lastFetchedDoctorID, this.categoryID})
      : super([lastFetchedDoctorID, categoryID]);
}

class SearchFromCategoricalDoctorsEvent extends CategoricalDoctorsEvent {
  final String searchTerm;
  final List<BasicDoctor> list;

  SearchFromCategoricalDoctorsEvent(this.searchTerm, this.list)
      : super([searchTerm, list]);
}
