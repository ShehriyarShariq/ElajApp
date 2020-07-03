part of 'home_doctor_bloc.dart';

abstract class HomeDoctorState extends Equatable {
  const HomeDoctorState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class Initial extends HomeDoctorState {}

class LoadingAppointments extends HomeDoctorState {}

class LoadingWallet extends HomeDoctorState {}

class LoadingProfile extends HomeDoctorState {}

class LoadedAppointments extends HomeDoctorState {
  final Map<DateTime, List<BasicAppointment>> appointments;

  LoadedAppointments({this.appointments}) : super([appointments]);
}

class LoadedWallet extends HomeDoctorState {
  final Wallet wallet;

  LoadedWallet({this.wallet}) : super([wallet]);
}

class LoadedProfile extends HomeDoctorState {
  final CompleteDoctor completeDoctor;

  LoadedProfile({this.completeDoctor}) : super([completeDoctor]);
}

class Error extends HomeDoctorState {}

class LoggingOut extends HomeDoctorState {}

class LogOut extends HomeDoctorState {}

class LogOutError extends HomeDoctorState {}
