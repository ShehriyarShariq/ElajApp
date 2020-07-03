part of 'home_doctor_bloc.dart';

abstract class HomeDoctorEvent extends Equatable {
  const HomeDoctorEvent([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class GetDoctorAppointmentsEvent extends HomeDoctorEvent {}

class GetDoctorWalletEvent extends HomeDoctorEvent {}

class GetDoctorProfileEvent extends HomeDoctorEvent {}

class ResetEvent extends HomeDoctorEvent {}

class LogOutEvent extends HomeDoctorEvent {}
