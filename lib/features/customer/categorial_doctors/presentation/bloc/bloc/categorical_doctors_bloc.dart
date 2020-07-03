import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:elaj/core/util/params.dart';
import 'package:elaj/features/customer/categorial_doctors/domain/entities/basic_doctor.dart';
import 'package:elaj/features/customer/categorial_doctors/domain/usecases/get_all_categorical_doctors.dart';
import 'package:elaj/features/customer/categorial_doctors/domain/usecases/search_from_categorical_doctors.dart';
import 'package:equatable/equatable.dart';

part 'categorical_doctors_event.dart';
part 'categorical_doctors_state.dart';

class CategoricalDoctorsBloc
    extends Bloc<CategoricalDoctorsEvent, CategoricalDoctorsState> {
  GetAllCategoricalDoctors getAllCategoricalDoctors;
  SearchFromCategoricalDoctors searchFromCategoricalDoctors;

  CategoricalDoctorsBloc(
      {GetAllCategoricalDoctors categoricalDoctors,
      SearchFromCategoricalDoctors search})
      : assert(categoricalDoctors != null),
        assert(search != null),
        getAllCategoricalDoctors = categoricalDoctors,
        searchFromCategoricalDoctors = search;

  @override
  CategoricalDoctorsState get initialState => Initial();

  @override
  Stream<CategoricalDoctorsState> mapEventToState(
    CategoricalDoctorsEvent event,
  ) async* {
    if (event is GetAllCategoricalDoctorsEvent) {
      yield Loading();
      final failureOrDoctors = await getAllCategoricalDoctors(
          CategoricalDoctorsParams(
              lastFetchedDoctorID: event.lastFetchedDoctorID,
              categoryID: event.categoryID));
      yield failureOrDoctors.fold(
          (failure) => Error(), (doctors) => Loaded(doctors: doctors));
    } else if (event is SearchFromCategoricalDoctorsEvent) {
      yield Loading();
      final failureOrQueriedDoctors = await searchFromCategoricalDoctors(
          SearchParams(searchTerm: event.searchTerm, list: event.list));
      yield failureOrQueriedDoctors.fold((failure) => Error(),
          (queriedDoctors) => SearchedDoctors(doctors: queriedDoctors));
    }
  }
}
