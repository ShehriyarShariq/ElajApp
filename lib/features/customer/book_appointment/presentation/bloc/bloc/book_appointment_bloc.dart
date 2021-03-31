import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/core/util/params.dart';
import 'package:elaj/features/customer/book_appointment/domain/entities/booking.dart'
    as BookingEntity;
import 'package:elaj/features/customer/book_appointment/domain/entities/booking.dart';
import 'package:elaj/features/customer/book_appointment/domain/entities/booking_singleton.dart';
import 'package:elaj/features/customer/book_appointment/domain/usecases/book_customer_appointment.dart';
import 'package:elaj/features/customer/book_appointment/domain/usecases/check_payment_status.dart';
import 'package:elaj/features/customer/book_appointment/domain/usecases/check_user.dart';
import 'package:elaj/features/customer/book_appointment/domain/usecases/get_doctor_timings.dart';
import 'package:elaj/features/doctor/availability/domain/entities/availability.dart';
import 'package:equatable/equatable.dart';

part 'book_appointment_event.dart';
part 'book_appointment_state.dart';

class BookAppointmentBloc
    extends Bloc<BookAppointmentEvent, BookAppointmentState> {
  GetDoctorTimings getDoctorTimings;
  BookCustomerAppointment bookCustomerAppointment;
  CheckPaymentStatus checkPaymentStatus;
  CheckUser checkUser;

  BookAppointmentBloc(
      {GetDoctorTimings doctorTimings,
      BookCustomerAppointment customerAppointment,
      CheckPaymentStatus paymentStatus,
      CheckUser user})
      : assert(doctorTimings != null),
        assert(customerAppointment != null),
        assert(paymentStatus != null),
        assert(user != null),
        getDoctorTimings = doctorTimings,
        bookCustomerAppointment = customerAppointment,
        checkPaymentStatus = paymentStatus,
        checkUser = user;

  @override
  BookAppointmentState get initialState => Initial();

  @override
  Stream<BookAppointmentState> mapEventToState(
    BookAppointmentEvent event,
  ) async* {
    if (event is GetDoctorTimingsEvent) {
      yield Loading();
      final failureOrAvailability =
          await getDoctorTimings(BookingParams(doctorID: event.doctorID));
      yield failureOrAvailability.fold((failure) => Error(),
          (availability) => Loaded(availability: availability));
    } else if (event is CheckUserEvent) {
      final failureOrSuccess = await checkUser(NoParams());
      yield failureOrSuccess.fold((failure) => UserCheck(isUser: false),
          (success) => UserCheck(isUser: true));
    } else if (event is ShowSelfEvent) {
      yield ShowSelf();
    } else if (event is ShowOtherEvent) {
      yield ShowOther();
    } else if (event is FetchAllValuesEvent) {
      yield FetchingData();
    } else if (event is SaveFetchedValueEvent) {
      BookingSingleton bookingSingleton = BookingSingleton();

      switch (event.type) {
        case "isSelf":
          bookingSingleton.booking.isSelf = event.property;

          if (event.property) {
            bookingSingleton.booking.other = null;
          } else {
            if (bookingSingleton.booking.other == null) {
              bookingSingleton.booking.other = Other();
            }
          }
          break;
        case "otherName":
          if (bookingSingleton.booking.other == null)
            bookingSingleton.booking.other = Other();

          bookingSingleton.booking.other.name = event.property;
          break;
        case "otherRelation":
          if (bookingSingleton.booking.other == null)
            bookingSingleton.booking.other = Other();

          bookingSingleton.booking.other.relationShip = event.property;
          break;
        case "otherGender":
          if (bookingSingleton.booking.other == null)
            bookingSingleton.booking.other = Other();

          bookingSingleton.booking.other.gender = event.property;
          break;
      }

      if (bookingSingleton.booking.isFullyInitialized()) {
        // final failureOrChecked = await checkPaymentStatus(AppointmentParams(
        //     startTime:
        //         bookingSingleton.booking.startTime.millisecondsSinceEpoch));
        // yield failureOrChecked.fold(
        //     (failure) => Error(msg: "Payment check failure! Try again."),
        //     (checked) => PaymentStatusChecked(isPayNow: checked));

        /* ----------------------------------------------------- */
        // REMOVE THIS AFTER PAYMENT ADDITION
        final failureOrSuccess = await bookCustomerAppointment(
            BookingParams(booking: bookingSingleton.booking));
        yield failureOrSuccess.fold(
            (failure) => Error(msg: "Booking failed! Try again."),
            (success) => Booked(isSuccess: success));
        /* ----------------------------------------------------- */

        bookingSingleton.booking.reset();
      }
    } else if (event is BookCustomerAppointmentEvent) {
      final failureOrSuccess =
          await bookCustomerAppointment(BookingParams(booking: event.booking));
      yield failureOrSuccess.fold(
          (failure) => Error(msg: "Booking failed! Try again."),
          (success) => Booked(isSuccess: success));

      BookingSingleton bookingSingleton = BookingSingleton();
      bookingSingleton.booking.reset();
    } else if (event is Reset) {
      yield Initial();
    } else if (event is DummyEvent) {
      yield Dummy();
    }
  }
}
