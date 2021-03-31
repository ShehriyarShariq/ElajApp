part of 'appointment_session_bloc.dart';

abstract class AppointmentSessionEvent extends Equatable {
  const AppointmentSessionEvent([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class GiveAppointmentRatingEvent extends AppointmentSessionEvent {
  final Review review;

  GiveAppointmentRatingEvent({this.review}) : super([review]);
}

class GivePrescriptionEvent extends AppointmentSessionEvent {
  final Prescription prescription;

  GivePrescriptionEvent({this.prescription}) : super([prescription]);
}

class OpenAcknowledgeDialogEvent extends AppointmentSessionEvent {
  final String appointmentID;

  OpenAcknowledgeDialogEvent({this.appointmentID}) : super([appointmentID]);
}

class AcknowledgeEarlyEndEvent extends AppointmentSessionEvent {
  final String appointmentID;
  final bool isEnd;

  AcknowledgeEarlyEndEvent({this.appointmentID, this.isEnd})
      : super([appointmentID, isEnd]);
}
