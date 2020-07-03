import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/features/common/all_appointments/domain/entities/basic_appointment.dart';
import 'package:elaj/features/doctor/complete_profile/domain/entities/complete_doctor.dart';
import 'package:elaj/features/doctor/home_doctor/domain/entities/wallet.dart';
import 'package:elaj/features/doctor/home_doctor/domain/usecases/get_doctor_appointments.dart';
import 'package:elaj/features/doctor/home_doctor/domain/usecases/get_doctor_profile.dart';
import 'package:elaj/features/doctor/home_doctor/domain/usecases/get_doctor_wallet.dart';
import 'package:elaj/features/doctor/home_doctor/domain/usecases/log_out_doctor.dart';
import 'package:equatable/equatable.dart';

part 'home_doctor_event.dart';
part 'home_doctor_state.dart';

class HomeDoctorBloc extends Bloc<HomeDoctorEvent, HomeDoctorState> {
  GetDoctorAppointments getDoctorAppointments;
  GetDoctorWallet getDoctorWallet;
  GetDoctorProfile getDoctorProfile;
  LogOutDoctor logOutDoctor;

  HomeDoctorBloc(
      {GetDoctorAppointments doctorAppointments,
      GetDoctorWallet doctorWallet,
      GetDoctorProfile doctorProfile,
      LogOutDoctor logOut})
      : assert(doctorAppointments != null),
        assert(doctorWallet != null),
        assert(doctorProfile != null),
        assert(logOut != null),
        getDoctorAppointments = doctorAppointments,
        getDoctorWallet = doctorWallet,
        getDoctorProfile = doctorProfile,
        logOutDoctor = logOut;

  @override
  HomeDoctorState get initialState => Initial();

  @override
  Stream<HomeDoctorState> mapEventToState(
    HomeDoctorEvent event,
  ) async* {
    if (event is GetDoctorAppointmentsEvent) {
      yield LoadingAppointments();
      final failureOrAppointments = await getDoctorAppointments(NoParams());
      yield failureOrAppointments.fold((failure) => Error(),
          (appointments) => LoadedAppointments(appointments: appointments));
    } else if (event is GetDoctorWalletEvent) {
      yield LoadingWallet();
      final failureOrWallet = await getDoctorWallet(NoParams());

      await Future.delayed(Duration(seconds: 2));

      yield failureOrWallet.fold(
          (failure) => Error(), (wallet) => LoadedWallet(wallet: wallet));
    } else if (event is GetDoctorProfileEvent) {
      yield LoadingProfile();
      final failureOrProfile = await getDoctorProfile(NoParams());
      yield failureOrProfile.fold((failure) => Error(),
          (completeDoctor) => LoadedProfile(completeDoctor: completeDoctor));
    } else if (event is ResetEvent) {
      yield Initial();
    } else if (event is LogOutEvent) {
      yield LoggingOut();
      final failureOrSuccess = await logOutDoctor(NoParams());
      yield failureOrSuccess.fold(
          (failure) => LogOutError(), (success) => LogOut());
    }
  }
}
