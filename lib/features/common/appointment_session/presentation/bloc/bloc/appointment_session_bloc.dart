import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'appointment_session_event.dart';
part 'appointment_session_state.dart';

class AppointmentSessionBloc extends Bloc<AppointmentSessionEvent, AppointmentSessionState> {
  @override
  AppointmentSessionState get initialState => AppointmentSessionInitial();

  @override
  Stream<AppointmentSessionState> mapEventToState(
    AppointmentSessionEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
