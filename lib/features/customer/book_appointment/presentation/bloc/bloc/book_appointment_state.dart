part of 'book_appointment_bloc.dart';

abstract class BookAppointmentState extends Equatable {
  const BookAppointmentState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class Initial extends BookAppointmentState {}

class Loading extends BookAppointmentState {}

class Loaded extends BookAppointmentState {
  final Availability availability;

  Loaded({this.availability}) : super([availability]);
}

class Booking extends BookAppointmentState {}

class Booked extends BookAppointmentState {
  final bool isSuccess;

  Booked({this.isSuccess}) : super([isSuccess]);
}

class Error extends BookAppointmentState {
  final String msg;

  Error({this.msg}) : super([msg]);
}

class ShowSelf extends BookAppointmentState {}

class ShowOther extends BookAppointmentState {}

class BookingError extends BookAppointmentState {}

class FetchingData extends BookAppointmentState {}

class PaymentStatusChecked extends BookAppointmentState {
  final bool isPayNow;

  PaymentStatusChecked({this.isPayNow}) : super([isPayNow]);
}

class UserCheck extends BookAppointmentState {
  final bool isUser;

  UserCheck({this.isUser}) : super([isUser]);
}

class Dummy extends BookAppointmentState {}
