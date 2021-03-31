import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:elaj/core/error/failures.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/core/util/params.dart';
import 'package:elaj/features/doctor/availability/domain/entities/availability.dart';
import 'package:elaj/features/doctor/availability/domain/entities/availability_singleton.dart';
import 'package:elaj/features/doctor/availability/domain/usecases/load_available_days.dart';
import 'package:elaj/features/doctor/availability/domain/usecases/save_available_days.dart';
import 'package:equatable/equatable.dart';

part 'availability_event.dart';
part 'availability_state.dart';

class AvailabilityBloc extends Bloc<AvailabilityEvent, AvailabilityState> {
  LoadAvailableDays loadAvailableDays;
  SaveAvailableDays saveAvailableDays;

  AvailabilityBloc({LoadAvailableDays loadDays, SaveAvailableDays saveDays})
      : assert(loadDays != null),
        assert(saveDays != null),
        loadAvailableDays = loadDays,
        saveAvailableDays = saveDays;

  @override
  AvailabilityState get initialState => Initial();

  @override
  Stream<AvailabilityState> mapEventToState(
    AvailabilityEvent event,
  ) async* {
    if (event is LoadAvailableDaysEvent) {
      yield Loading();
      final failureOrAvailability = await loadAvailableDays(NoParams());
      yield failureOrAvailability.fold(
          (failure) => Error(msg: "Some error occurred! Try again"),
          (availability) => Loaded(availability: availability));

      // Availability availability = new Availability();

      // availability.availableDays = new List();
      // availability.availableDays.add(AvailableDay(date: DateTime.now()));
    } else if (event is FetchAllDataEvent) {
      yield Fetching();
    } else if (event is SaveFetchedDataEvent) {
      AvailabilitySingleton availabilitySingleton = AvailabilitySingleton();

      availabilitySingleton.availability.availableDays[event.index] =
          event.property;

      bool isFetchedAll = false;
      for (int i = 0;
          i < availabilitySingleton.availability.availableDays.length;
          i++) {
        if (availabilitySingleton.availability.availableDays[i] != null) {
          isFetchedAll = true;
          // break;
        } else {
          isFetchedAll = false;
        }
      }

      if (isFetchedAll) {
        if (Availability.encodeAvailableDaysList(
                    availabilitySingleton.availability.availableDays)
                .length ==
            0) {
          yield SnackBarError(msg: "Must select atleast one day");
          availabilitySingleton.reset();
        } else {
          yield Processing();
          final failureOrSaved = await saveAvailableDays(AvailabilityParams(
              availability: availabilitySingleton.availability));
          yield failureOrSaved.fold(
              (failure) => SnackBarError(msg: "Some error occurred! Try again"),
              (list) =>
                  list.length == 0 ? Saved() : SlotError(invalidDays: list));
          availabilitySingleton.reset();
        }
      }
    } else if (event is Reset) {
      yield Initial();
    }
  }
}
