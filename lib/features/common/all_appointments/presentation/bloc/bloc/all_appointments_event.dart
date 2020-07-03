part of 'all_appointments_bloc.dart';

abstract class AllAppointmentsEvent extends Equatable {
  const AllAppointmentsEvent([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class GetAllCurrentAppointmentsEvent extends AllAppointmentsEvent {}

class GetAllPastAppointmentsEvent extends AllAppointmentsEvent {}
