import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/core/util/params.dart';
import 'package:elaj/features/customer/home_customer/domain/entities/category.dart';
import 'package:elaj/features/doctor/availability/presentation/bloc/bloc/availability_bloc.dart';
import 'package:elaj/features/doctor/complete_profile/domain/entities/complete_doctor.dart';
import 'package:elaj/features/doctor/complete_profile/domain/entities/complete_doctor_singleton.dart';
import 'package:elaj/features/doctor/complete_profile/domain/usecases/load_init_data.dart';
import 'package:elaj/features/doctor/complete_profile/domain/usecases/save_complete_profile.dart';
import 'package:elaj/features/doctor/complete_profile/domain/usecases/select_specialties_from_list.dart';
import 'package:equatable/equatable.dart';

part 'complete_profile_event.dart';
part 'complete_profile_state.dart';

class CompleteProfileBloc
    extends Bloc<CompleteProfileEvent, CompleteProfileState> {
  LoadInitData loadInitData;
  SaveCompleteProfile saveCompleteProfile;
  SelectSpecialtiesFromList selectSpecialtiesFromList;

  int pageOneCounter = 0,
      pageOneTotal = 7,
      pageTwoCounter = 0,
      pageTwoTotal = 3;

  CompleteProfileBloc(
      {LoadInitData initData,
      SaveCompleteProfile saveProfile,
      SelectSpecialtiesFromList specialties})
      : assert(initData != null),
        assert(saveProfile != null),
        assert(specialties != null),
        loadInitData = initData,
        saveCompleteProfile = saveProfile,
        selectSpecialtiesFromList = specialties;

  @override
  CompleteProfileState get initialState => Initial();

  @override
  Stream<CompleteProfileState> mapEventToState(
    CompleteProfileEvent event,
  ) async* {
    if (event is LoadInitDataEvent) {
      yield Loading();
      final failureOrLoaded = await loadInitData(NoParams());
      yield failureOrLoaded.fold(
          (failure) => Error(), (initData) => Loaded(initData: initData));
    } else if (event is FetchAllDataEvent) {
      yield Fetching();
    } else if (event is FetchAllChildFieldDataEvent) {
      yield FetchingChildFieldData(parentType: event.parentType);
    } else if (event is GoToPrevPageEvent) {
      pageOneCounter = 0;
      pageTwoCounter = 0;
      yield GoToPrevPage();
    } else if (event is SearchFromCategoriesEvent) {
      yield LoadingCategories();
      final failureOrQueriedCategories = await selectSpecialtiesFromList(
          SearchParams(searchTerm: event.searchTerm, list: event.list));
      yield failureOrQueriedCategories.fold(
          (failure) {},
          (queriedCategories) =>
              SearchedCategories(queriedCategories: queriedCategories));
    } else if (event is SaveFetchedDataEvent) {
      CompleteDoctorSingleton completeDoctorSingleton =
          CompleteDoctorSingleton();

      switch (event.type) {
        case "specialty":
          completeDoctorSingleton.completeDoctor.specialties = event.property;
          pageOneCounter += 1;
          break;
        case "pmdc":
          completeDoctorSingleton.completeDoctor.pmdcNum = event.property;
          pageOneCounter += 1;
          break;
        case "profileImg":
          completeDoctorSingleton.completeDoctor.profileImgFile =
              event.property;
          pageOneCounter += 1;
          break;
        case "liscenseImg":
          completeDoctorSingleton.completeDoctor.liscenseImgFile =
              event.property;
          pageOneCounter += 1;
          break;
        case "degreeImg":
          completeDoctorSingleton.completeDoctor.degreeImgFile = event.property;
          pageOneCounter += 1;
          break;
        case "certification":
          completeDoctorSingleton.completeDoctor.certification = event.property;
          pageOneCounter += 1;
          break;
        case "experience":
          completeDoctorSingleton.completeDoctor.experience = event.property;
          pageOneCounter += 1;
          break;
        case "overview":
          completeDoctorSingleton.completeDoctor.overview = event.property;
          pageOneCounter += 1;
          break;
        case "education":
          completeDoctorSingleton.completeDoctor.education =
              (event.property as List<dynamic>).cast<Education>().toList();
          pageTwoCounter += 1;
          break;
        case "employmentHist":
          completeDoctorSingleton.completeDoctor.employmentHist =
              (event.property as List<dynamic>)
                  .cast<EmploymentHistory>()
                  .toList();
          pageTwoCounter += 1;
          break;
        case "rate":
          completeDoctorSingleton.completeDoctor.rate =
              int.parse(event.property);
          pageTwoCounter += 1;
          break;
        case "address":
          if (completeDoctorSingleton.completeDoctor.location == null)
            completeDoctorSingleton.completeDoctor.location = Location();

          completeDoctorSingleton.completeDoctor.location.address =
              event.property;
          break;
        case "city":
          if (completeDoctorSingleton.completeDoctor.location == null)
            completeDoctorSingleton.completeDoctor.location = Location();

          completeDoctorSingleton.completeDoctor.location.city = event.property;
          break;
        case "province":
          if (completeDoctorSingleton.completeDoctor.location == null)
            completeDoctorSingleton.completeDoctor.location = Location();

          completeDoctorSingleton.completeDoctor.location.province =
              event.property;
          break;
        case "zip":
          if (completeDoctorSingleton.completeDoctor.location == null)
            completeDoctorSingleton.completeDoctor.location = Location();

          completeDoctorSingleton.completeDoctor.location.zip = event.property;
          break;
        case "country":
          if (completeDoctorSingleton.completeDoctor.location == null)
            completeDoctorSingleton.completeDoctor.location = Location();

          completeDoctorSingleton.completeDoctor.location.country =
              event.property;
          break;
      }

      if (event.pageNum == 1 &&
          completeDoctorSingleton.completeDoctor.isFirstFullyInitialized() &&
          pageOneCounter == pageOneTotal) {
        pageOneCounter = 0;
        yield GoToNextPage();
      } else if (event.pageNum == 2 &&
          completeDoctorSingleton.completeDoctor.isSecondFullyInitialized() &&
          pageTwoCounter == pageTwoTotal) {
        pageTwoCounter = 0;
        yield GoToNextPage();
      } else if (event.pageNum == 3 &&
          completeDoctorSingleton.completeDoctor.isFullyInitialized()) {
        final failureOrSaved = await saveCompleteProfile(CompleteProfileParams(
            completeDoctor: completeDoctorSingleton.completeDoctor));
        yield failureOrSaved.fold(
            (failure) => Error(), (saved) => Saved(isSaved: saved));
      }
    } else if (event is SaveFetchedDataToParentEvent) {
      yield FetchedChildFieldData(
          type: event.type,
          parentIndex: event.parentIndex,
          parentType: event.parentType,
          property: event.property);
    } else if (event is ResetEvent) {
      yield Initial();
    }
  }
}
