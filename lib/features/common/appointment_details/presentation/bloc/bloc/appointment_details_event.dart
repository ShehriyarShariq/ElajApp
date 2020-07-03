part of 'appointment_details_bloc.dart';

abstract class AppointmentDetailsEvent extends Equatable {
  const AppointmentDetailsEvent([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class LoadAppointmentEvent extends AppointmentDetailsEvent {
  String appointmentID;

  LoadAppointmentEvent({this.appointmentID}) : super([appointmentID]);
}

class JoinSessionEvent extends AppointmentDetailsEvent {
  num startTime;

  JoinSessionEvent({this.startTime}) : super([startTime]);
}

class CancelBookingStatusCheckEvent extends AppointmentDetailsEvent {
  final String appointmentID;
  final int startTime;

  CancelBookingStatusCheckEvent({this.appointmentID, this.startTime});
}

class CancelBookingEvent extends AppointmentDetailsEvent {
  final String appointmentID;
  final bool withPenalty;

  CancelBookingEvent({this.appointmentID, this.withPenalty});
}
