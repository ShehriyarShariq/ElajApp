import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:elaj/core/util/params.dart';
import 'package:elaj/features/common/appointment_session/domain/entities/prescription.dart';
import 'package:elaj/features/common/appointment_session/domain/entities/review.dart';
import 'package:elaj/features/common/appointment_session/domain/usecases/acknowledge_early_end.dart';
import 'package:elaj/features/common/appointment_session/domain/usecases/give_appointment_rating.dart';
import 'package:elaj/features/common/appointment_session/domain/usecases/give_prescription.dart';
import 'package:equatable/equatable.dart';

part 'appointment_session_event.dart';
part 'appointment_session_state.dart';

class AppointmentSessionBloc
    extends Bloc<AppointmentSessionEvent, AppointmentSessionState> {
  GiveAppointmentRating giveAppointmentRating;
  GivePrescription givePrescription;
  AcknowledgeEarlyEnd acknowledgeEarlyEnd;

  AppointmentSessionBloc(
      {GiveAppointmentRating appointmentRating,
      GivePrescription prescription,
      AcknowledgeEarlyEnd earlyEnd})
      : assert(appointmentRating != null),
        assert(prescription != null),
        assert(earlyEnd != null),
        giveAppointmentRating = appointmentRating,
        givePrescription = prescription,
        acknowledgeEarlyEnd = earlyEnd;

  @override
  AppointmentSessionState get initialState => Initial();

  @override
  Stream<AppointmentSessionState> mapEventToState(
    AppointmentSessionEvent event,
  ) async* {
    if (event is GiveAppointmentRatingEvent) {
      yield Rating();
      final failureOrSuccess =
          await giveAppointmentRating(RatingParams(rating: event.review));
      yield failureOrSuccess.fold(
          (failure) => RetryError(), (success) => Success());
    } else if (event is GivePrescriptionEvent) {
      yield Prescribing();
      final failureOrSuccess = await givePrescription(
          PrescriptionParams(prescription: event.prescription));
      yield failureOrSuccess.fold(
          (failure) => RetryError(), (success) => Success());
    } else if (event is AcknowledgeEarlyEndEvent) {
      yield Acknowledging();
      final failureOrSuccess = await acknowledgeEarlyEnd(AcknowledgementParams(
          appointmentID: event.appointmentID,
          isEnd: event.isEnd,
          forCust: event.isEnd));
      yield failureOrSuccess.fold(
          (failure) => RetryError(), (success) => Acknowledged());
    } else if (event is OpenAcknowledgeDialogEvent) {
      yield OpeningAckDialog();
      final failureOrSuccess = await acknowledgeEarlyEnd(AcknowledgementParams(
          appointmentID: event.appointmentID, isEnd: true, forCust: false));
      yield failureOrSuccess.fold(
          (failure) => DialogOpenError(), (success) => OpenAckDialog());
    }
  }
}
