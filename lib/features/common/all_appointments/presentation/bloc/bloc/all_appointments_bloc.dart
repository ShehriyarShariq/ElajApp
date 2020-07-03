import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:elaj/core/error/failures.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/features/common/all_appointments/domain/entities/basic_appointment.dart';
import 'package:elaj/features/common/all_appointments/domain/usecases/get_current_appointments.dart';
import 'package:elaj/features/common/all_appointments/domain/usecases/get_past_appointments.dart';
import 'package:equatable/equatable.dart';

part 'all_appointments_event.dart';
part 'all_appointments_state.dart';

class AllAppointmentsBloc
    extends Bloc<AllAppointmentsEvent, AllAppointmentsState> {
  GetAllCurrentAppointments getAllCurrentAppointments;
  GetAllPastAppointments getAllPastAppointments;

  AllAppointmentsBloc(
      {GetAllCurrentAppointments allCurrentAppointments,
      GetAllPastAppointments allPastAppointments})
      : assert(allCurrentAppointments != null),
        assert(allPastAppointments != null),
        getAllCurrentAppointments = allCurrentAppointments,
        getAllPastAppointments = allPastAppointments;

  @override
  AllAppointmentsState get initialState => Initial();

  @override
  Stream<AllAppointmentsState> mapEventToState(
    AllAppointmentsEvent event,
  ) async* {
    yield Loading();
    final failureOrAppointments = event is GetAllCurrentAppointmentsEvent
        ? await getAllCurrentAppointments(NoParams())
        : await getAllPastAppointments(NoParams());
    yield failureOrAppointments.fold(
        (failure) => failure is UnauthorizedUserFailure
            ? ErrorUserNotLoggedIn()
            : Error(),
        (appointments) => Loaded(appointments: appointments));
  }
}
