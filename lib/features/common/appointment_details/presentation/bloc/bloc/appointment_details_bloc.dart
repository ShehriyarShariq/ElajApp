import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:elaj/core/util/constants.dart';
import 'package:elaj/core/util/params.dart';
import 'package:elaj/features/common/all_appointments/domain/entities/basic_appointment.dart';
import 'package:elaj/features/common/appointment_details/domain/usecases/cancel_appointment.dart';
import 'package:elaj/features/common/appointment_details/domain/usecases/check_cancellation_status.dart';
import 'package:elaj/features/common/appointment_details/domain/usecases/check_join_session_status.dart';
import 'package:elaj/features/common/appointment_details/domain/usecases/get_appointment_details.dart';
import 'package:elaj/features/customer/add_medical_record/domain/entities/medical_record.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'appointment_details_event.dart';
part 'appointment_details_state.dart';

class AppointmentDetailsBloc
    extends Bloc<AppointmentDetailsEvent, AppointmentDetailsState> {
  final GetAppointmentDetails getAppointmentDetails;
  final CancelAppointment cancelAppointment;
  final CheckCancellationStatus checkCancellationStatus;
  final CheckJoinSessionStatus checkJoinSessionStatus;

  AppointmentDetailsBloc(
      {@required GetAppointmentDetails appointmentDetails,
      @required CancelAppointment cancel,
      @required CheckCancellationStatus cancellationStatus,
      @required CheckJoinSessionStatus joinSessionStatus})
      : assert(appointmentDetails != null),
        assert(cancel != null),
        assert(cancellationStatus != null),
        assert(joinSessionStatus != null),
        getAppointmentDetails = appointmentDetails,
        cancelAppointment = cancel,
        checkCancellationStatus = cancellationStatus,
        checkJoinSessionStatus = joinSessionStatus;

  @override
  AppointmentDetailsState get initialState => Initial();

  @override
  Stream<AppointmentDetailsState> mapEventToState(
    AppointmentDetailsEvent event,
  ) async* {
    if (event is LoadAppointmentEvent) {
      yield Loading();
      final failureOrAppointment = await getAppointmentDetails(
          AppointmentParams(appointmentID: event.appointmentID));
      yield failureOrAppointment.fold((failure) => Error(),
          (appointment) => Loaded(appointment: appointment));

      // await Future.delayed(const Duration(seconds: 2));

      // Map<String, dynamic> appointmentMap = {
      //   'id': 'appointment01',
      //   'name': 'Shehriyar Shariq',
      //   'photoURL':
      //       'https://firebasestorage.googleapis.com/v0/b/elaj-5624b.appspot.com/o/doctor%2FpvmwLXjLX9bCG8KDlkZKXpBxrJu1%2FprofileImg.png?alt=media&token=c4f5a017-5720-4cef-b198-e9990bb59801',
      //   'status': 'assigned',
      //   'start':
      //       DateTime.now().add(Duration(minutes: 1)).millisecondsSinceEpoch,
      //   'end': DateTime.now()
      //       .add(Duration(
      //           minutes: 2)) //days: 1, minutes: Constant.SESSION_LENGTH))
      //       .millisecondsSinceEpoch,
      //   'createdAt': DateTime.now().millisecondsSinceEpoch,
      //   'isPaid': false,
      //   'medicalRecords': [
      //     MedicalRecord(
      //         id: 'medicalRecord01',
      //         desc: 'None',
      //         date: DateTime.now(),
      //         images: {
      //           'test':
      //               'https://firebasestorage.googleapis.com/v0/b/elaj-5624b.appspot.com/o/doctor%2FpvmwLXjLX9bCG8KDlkZKXpBxrJu1%2FprofileImg.png?alt=media&token=c4f5a017-5720-4cef-b198-e9990bb59801'
      //         })
      //   ]
      // };

      // BasicAppointment appointment =
      //     new BasicAppointment.fromJson(appointmentMap);

      // yield Loaded(appointment: appointment);
    } else if (event is JoinSessionEvent) {
      final failureOrResult = await checkJoinSessionStatus(
          AppointmentParams(startTime: event.startTime));
      yield failureOrResult.fold((failure) => Error(),
          (result) => result ? JoinSessionAllowed() : JoinSessionDenied());
    } else if (event is CancelBookingStatusCheckEvent) {
      yield CheckingCancellationStatus();
      // final failureOrStatus = await checkCancellationStatus(AppointmentParams(
      //     appointmentID: event.appointmentID, startTime: event.startTime));
      // yield failureOrStatus.fold(
      //     (failure) => Error(msg: "Cancellation Failed!"),
      //     (status) => CheckedCancellationStatus(status: status));

      await Future.delayed(const Duration(seconds: 2));

      Map<String, dynamic> statusMap = new Map();
      statusMap['isAllowed'] = false;
      statusMap['message'] =
          "Cancelling this appointment won't result in any penalty. Do you wish to continue?";

      yield CheckedCancellationStatus(status: statusMap);
    } else if (event is CancelBookingEvent) {
      yield Cancelling();
      final failureOrSuccess = await cancelAppointment(AppointmentParams(
          appointmentID: event.appointmentID, withPenalty: event.withPenalty));
      yield failureOrSuccess.fold(
          (failure) => Error(msg: "Cancellation Failed!"),
          (success) => Cancelled());
    }
  }
}
