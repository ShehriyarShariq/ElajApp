part of 'appointment_session_bloc.dart';

abstract class AppointmentSessionState extends Equatable {
  const AppointmentSessionState();
}

class AppointmentSessionInitial extends AppointmentSessionState {
  @override
  List<Object> get props => [];
}
