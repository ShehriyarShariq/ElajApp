part of 'appointment_details_bloc.dart';

abstract class AppointmentDetailsState extends Equatable {
  const AppointmentDetailsState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class Initial extends AppointmentDetailsState {}

class Loading extends AppointmentDetailsState {}

class Loaded extends AppointmentDetailsState {
  final BasicAppointment appointment;

  Loaded({this.appointment}) : super([appointment]);
}

class Error extends AppointmentDetailsState {
  final String msg;

  Error({this.msg});
}

class JoinSessionAllowed extends AppointmentDetailsState {}

class JoinSessionDenied extends AppointmentDetailsState {}

class CheckingCancellationStatus extends AppointmentDetailsState {}

class CheckedCancellationStatus extends AppointmentDetailsState {
  final Map<String, dynamic> status;

  CheckedCancellationStatus({this.status}) : super([status]);
}

class Cancelling extends AppointmentDetailsState {}

class Cancelled extends AppointmentDetailsState {}
