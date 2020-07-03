part of 'book_appointment_bloc.dart';

abstract class BookAppointmentEvent extends Equatable {
  const BookAppointmentEvent([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class GetDoctorTimingsEvent extends BookAppointmentEvent {
  final String doctorID;

  GetDoctorTimingsEvent({this.doctorID}) : super([doctorID]);
}

class BookCustomerAppointmentEvent extends BookAppointmentEvent {
  final BookingEntity.Booking booking;

  BookCustomerAppointmentEvent({this.booking}) : super([booking]);
}

class FetchAllValuesEvent extends BookAppointmentEvent {}

class SaveFetchedValueEvent extends BookAppointmentEvent {
  final property;
  final String type;

  SaveFetchedValueEvent({this.property, this.type}) : super([property, type]);
}

class ShowSelfEvent extends BookAppointmentEvent {}

class ShowOtherEvent extends BookAppointmentEvent {}

class Reset extends BookAppointmentEvent {}
