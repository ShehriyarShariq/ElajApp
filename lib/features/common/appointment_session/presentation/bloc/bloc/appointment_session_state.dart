part of 'appointment_session_bloc.dart';

abstract class AppointmentSessionState extends Equatable {
  const AppointmentSessionState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class Initial extends AppointmentSessionState {}

class Rating extends AppointmentSessionState {}

class SkipRating extends AppointmentSessionState {}

class Prescribing extends AppointmentSessionState {}

class Acknowledging extends AppointmentSessionState {}

class OpeningAckDialog extends AppointmentSessionState {}

class OpenAckDialog extends AppointmentSessionState {}

class Acknowledged extends AppointmentSessionState {}

class Success extends AppointmentSessionState {}

class RetryError extends AppointmentSessionState {}

class DialogOpenError extends AppointmentSessionState {}
