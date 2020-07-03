import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:elaj/core/error/failures.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/core/util/params.dart';
import 'package:elaj/features/customer/add_medical_record/domain/entities/medical_record.dart';
import 'package:elaj/features/customer/home_customer/domain/entities/category.dart';
import 'package:elaj/features/customer/home_customer/domain/usecases/get_all_categories.dart';
import 'package:elaj/features/customer/home_customer/domain/usecases/get_all_medical_records.dart';
import 'package:elaj/features/customer/home_customer/domain/usecases/log_out_customer.dart';
import 'package:elaj/features/customer/home_customer/domain/usecases/search_from_categories.dart';
import 'package:equatable/equatable.dart';

part 'home_customer_event.dart';
part 'home_customer_state.dart';

class HomeCustomerBloc extends Bloc<HomeCustomerEvent, HomeCustomerState> {
  GetAllCategories getAllCategories;
  GetAllMedicalRecords getAllMedicalRecords;
  SearchFromCategories searchFromCategories;
  LogOutCustomer logOutCustomer;

  HomeCustomerBloc(
      {GetAllCategories allCategories,
      GetAllMedicalRecords medicalRecords,
      SearchFromCategories fromCategories,
      LogOutCustomer logOut})
      : assert(allCategories != null),
        assert(medicalRecords != null),
        assert(fromCategories != null),
        assert(logOut != null),
        getAllCategories = allCategories,
        getAllMedicalRecords = medicalRecords,
        searchFromCategories = fromCategories,
        logOutCustomer = logOut;

  @override
  HomeCustomerState get initialState => Initial();

  @override
  Stream<HomeCustomerState> mapEventToState(
    HomeCustomerEvent event,
  ) async* {
    if (event is GetAllCategoriesEvent) {
      yield LoadingCategories();
      final failureOrCategories = await getAllCategories(NoParams());
      yield failureOrCategories.fold((failure) => ErrorCategories(),
          (categories) => LoadedCategories(categories: categories));
    } else if (event is GetAllMedicalRecordsEvent) {
      yield LoadingRecords();
      final failureOrMedicalRecords = await getAllMedicalRecords(NoParams());
      yield failureOrMedicalRecords.fold(
          (failure) => failure is UnauthorizedUserFailure
              ? ErrorUserNotLoggedIn()
              : ErrorMedicalRecords(),
          (medicalRecords) => LoadedRecords(medicalRecords: medicalRecords));
    } else if (event is SearchFromCategoriesEvent) {
      yield LoadingCategories();
      final failureOrQueriedCategories = await searchFromCategories(
          SearchParams(searchTerm: event.searchTerm, list: event.list));
      yield failureOrQueriedCategories.fold(
          (failure) => ErrorCategories(),
          (queriedCategories) =>
              SearchedCategories(queriedCategories: queriedCategories));
    } else if (event is LogOutEvent) {
      yield LoggingOut();
      final failureOrSuccess = await logOutCustomer(NoParams());
      yield failureOrSuccess.fold(
          (failure) => LogOutError(), (success) => LogOut());
    }
  }
}
