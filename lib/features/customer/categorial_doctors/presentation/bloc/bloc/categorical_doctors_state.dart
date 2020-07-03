part of 'categorical_doctors_bloc.dart';

abstract class CategoricalDoctorsState extends Equatable {
  const CategoricalDoctorsState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class Initial extends CategoricalDoctorsState {}

class Loading extends CategoricalDoctorsState {}

class Loaded extends CategoricalDoctorsState {
  final List<BasicDoctor> doctors;

  Loaded({this.doctors}) : super([doctors]);
}

class SearchedDoctors extends CategoricalDoctorsState {
  final List<BasicDoctor> doctors;

  SearchedDoctors({this.doctors}) : super([doctors]);
}

class Error extends CategoricalDoctorsState {}
