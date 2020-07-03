part of 'all_appointments_bloc.dart';

abstract class AllAppointmentsState extends Equatable {
  const AllAppointmentsState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class Initial extends AllAppointmentsState {}

class Loading extends AllAppointmentsState {}

class Loaded extends AllAppointmentsState {
  final List<BasicAppointment> appointments;

  Loaded({this.appointments}) : super([appointments]);
}

class Error extends AllAppointmentsState {}

class ErrorUserNotLoggedIn extends AllAppointmentsState {}
