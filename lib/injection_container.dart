import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';

import 'core/network/network_info.dart';
import 'features/common/all_appointments/data/repositories/all_appointments_repository_impl.dart';
import 'features/common/all_appointments/domain/repositories/all_appointments_repository.dart';
import 'features/common/all_appointments/domain/usecases/get_current_appointments.dart';
import 'features/common/all_appointments/domain/usecases/get_past_appointments.dart';
import 'features/common/all_appointments/presentation/bloc/bloc/all_appointments_bloc.dart';
import 'features/common/app_feedback/data/repositories/app_feedback_repository_impl.dart';
import 'features/common/app_feedback/domain/repositories/app_feedback_repository.dart';
import 'features/common/app_feedback/domain/usecases/give_feedback.dart';
import 'features/common/app_feedback/presentation/bloc/bloc/app_feedback_bloc.dart';
import 'features/common/appointment_details/data/repositories/appointment_details_repository_impl.dart';
import 'features/common/appointment_details/domain/repositories/appointment_details_repository.dart';
import 'features/common/appointment_details/domain/usecases/cancel_appointment.dart';
import 'features/common/appointment_details/domain/usecases/check_cancellation_status.dart';
import 'features/common/appointment_details/domain/usecases/check_join_session_status.dart';
import 'features/common/appointment_details/domain/usecases/get_appointment_details.dart';
import 'features/common/appointment_details/presentation/bloc/bloc/appointment_details_bloc.dart';
import 'features/common/credentials/data/repositories/credentials_repository_impl.dart';
import 'features/common/credentials/domain/repositories/credentials_repository.dart';
import 'features/common/credentials/domain/usecases/sign_in_with_credentials.dart';
import 'features/common/credentials/domain/usecases/sign_up_with_credentials.dart';
import 'features/common/credentials/presentation/bloc/bloc/credentials_bloc.dart';
import 'features/common/splash/data/repositories/splash_repository_impl.dart';
import 'features/common/splash/domain/repositories/splash_repository.dart';
import 'features/common/splash/domain/usecases/check_current_user.dart';
import 'features/common/splash/presentation/bloc/bloc/splash_bloc.dart';
import 'features/customer/add_medical_record/data/repositories/add_medical_records_repository_impl.dart';
import 'features/customer/add_medical_record/domain/repositories/add_medical_records_repository.dart';
import 'features/customer/add_medical_record/domain/usecases/upload_medical_record.dart';
import 'features/customer/add_medical_record/presentation/bloc/bloc/add_medical_records_bloc.dart';
import 'features/customer/book_appointment/data/repositories/book_appointment_repository_impl.dart';
import 'features/customer/book_appointment/domain/repositories/book_appointment_repository.dart';
import 'features/customer/book_appointment/domain/usecases/book_customer_appointment.dart';
import 'features/customer/book_appointment/domain/usecases/check_payment_status.dart';
import 'features/customer/book_appointment/domain/usecases/get_doctor_timings.dart';
import 'features/customer/book_appointment/presentation/bloc/bloc/book_appointment_bloc.dart';
import 'features/customer/categorial_doctors/data/repositories/categorical_doctors_repository_impl.dart';
import 'features/customer/categorial_doctors/domain/repositories/categorical_doctors_repository.dart';
import 'features/customer/categorial_doctors/domain/usecases/get_all_categorical_doctors.dart';
import 'features/customer/categorial_doctors/domain/usecases/search_from_categorical_doctors.dart';
import 'features/customer/categorial_doctors/presentation/bloc/bloc/categorical_doctors_bloc.dart';
import 'features/customer/doctor_profile_customer_view/data/repositories/doctor_profile_customer_view_repository_impl.dart';
import 'features/customer/doctor_profile_customer_view/domain/repositories/doctor_profile_customer_view_repository.dart';
import 'features/customer/doctor_profile_customer_view/domain/usecases/get_doctor_profile.dart';
import 'features/customer/doctor_profile_customer_view/domain/usecases/get_doctor_reviews.dart';
import 'features/customer/doctor_profile_customer_view/presentation/bloc/bloc/doctor_profile_customer_view_bloc.dart';
import 'features/customer/home_customer/data/repositories/home_repository_impl.dart';
import 'features/customer/home_customer/domain/repositories/home_repository.dart';
import 'features/customer/home_customer/domain/usecases/get_all_categories.dart';
import 'features/customer/home_customer/domain/usecases/get_all_medical_records.dart';
import 'features/customer/home_customer/domain/usecases/log_out_customer.dart';
import 'features/customer/home_customer/domain/usecases/search_from_categories.dart';
import 'features/customer/home_customer/presentation/bloc/bloc/home_customer_bloc.dart';
import 'features/doctor/availability/data/repositories/availability_repository_impl.dart';
import 'features/doctor/availability/domain/repositories/availability_repository.dart';
import 'features/doctor/availability/domain/usecases/load_available_days.dart';
import 'features/doctor/availability/domain/usecases/save_available_days.dart';
import 'features/doctor/availability/presentation/bloc/bloc/availability_bloc.dart';
import 'features/doctor/complete_profile/data/repositories/complete_profile_repository_impl.dart';
import 'features/doctor/complete_profile/domain/repositories/complete_profile_repository.dart';
import 'features/doctor/complete_profile/domain/usecases/load_init_data.dart';
import 'features/doctor/complete_profile/domain/usecases/save_complete_profile.dart';
import 'features/doctor/complete_profile/domain/usecases/select_specialties_from_list.dart';
import 'features/doctor/complete_profile/presentation/bloc/bloc/complete_profile_bloc.dart';
import 'features/doctor/home_doctor/data/repositories/home_doctor_repository_impl.dart';
import 'features/doctor/home_doctor/domain/repositories/home_doctor_repository.dart';
import 'features/doctor/home_doctor/domain/usecases/get_doctor_appointments.dart';
import 'features/doctor/home_doctor/domain/usecases/get_doctor_profile.dart'
    as DoctorHome;
import 'features/doctor/home_doctor/domain/usecases/get_doctor_wallet.dart';
import 'features/doctor/home_doctor/domain/usecases/log_out_doctor.dart';
import 'features/doctor/home_doctor/presentation/bloc/bloc/home_doctor_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Splash
  // Bloc
  sl.registerFactory(() => SplashBloc(currentUser: sl()));

  // Use Cases
  sl.registerLazySingleton(() => CheckCurrentUser(sl()));

  // Repository
  sl.registerLazySingleton<SplashRepository>(
      () => SplashRepositoryImpl(networkInfo: sl()));

  //! Features - App Feedback
  // Bloc
  sl.registerFactory(() => AppFeedbackBloc(feedback: sl()));

  // Use Cases
  sl.registerLazySingleton(() => GiveFeedback(sl()));

  // Repository
  sl.registerLazySingleton<AppFeedbackRepository>(
      () => AppFeedbackRepositoryImpl(networkInfo: sl()));

  //! Features - Customer - All Appointment
  // Bloc
  sl.registerFactory(() => AllAppointmentsBloc(
      allCurrentAppointments: sl(), allPastAppointments: sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetAllCurrentAppointments(sl()));
  sl.registerLazySingleton(() => GetAllPastAppointments(sl()));

  // Repository
  sl.registerLazySingleton<AllAppointmentsRepository>(
      () => AllAppointmentsRepositoryImpl(networkInfo: sl()));

  //! Features - Customer - Appointment Details
  // Bloc
  sl.registerFactory(() => AppointmentDetailsBloc(
      appointmentDetails: sl(),
      cancel: sl(),
      cancellationStatus: sl(),
      joinSessionStatus: sl()));

  // Use Cases
  sl.registerLazySingleton(() => CancelAppointment(sl()));
  sl.registerLazySingleton(() => CheckCancellationStatus(sl()));
  sl.registerLazySingleton(() => CheckJoinSessionStatus(sl()));
  sl.registerLazySingleton(() => GetAppointmentDetails(sl()));

  // Repository
  sl.registerLazySingleton<AppointmentDetailsRepository>(
      () => AppointmentDetailsRepositoryImpl(networkInfo: sl()));

  //! Features - Customer - Doctor Profile Customer View
  // Bloc
  sl.registerFactory(() =>
      DoctorProfileCustomerViewBloc(doctorProfile: sl(), doctorReviews: sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetDoctorProfile(sl()));
  sl.registerLazySingleton(() => GetDoctorReviews(sl()));

  // Repository
  sl.registerLazySingleton<DoctorProfileCustomerViewRepository>(
      () => DoctorProfileCustomerViewRepositoryImpl(networkInfo: sl()));

  //! Features - Customer - Book Appointment
  // Bloc
  sl.registerFactory(() => BookAppointmentBloc(
      doctorTimings: sl(), customerAppointment: sl(), paymentStatus: sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetDoctorTimings(sl()));
  sl.registerLazySingleton(() => BookCustomerAppointment(sl()));
  sl.registerLazySingleton(() => CheckPaymentStatus(sl()));

  // Repository
  sl.registerLazySingleton<BookAppointmentRepository>(
      () => BookAppointmentRepositoryImpl(networkInfo: sl()));

  //! Features - Customer - Doctor Availability
  // Bloc
  sl.registerFactory(() => AvailabilityBloc(loadDays: sl(), saveDays: sl()));

  // Use Cases
  sl.registerLazySingleton(() => LoadAvailableDays(sl()));
  sl.registerLazySingleton(() => SaveAvailableDays(sl()));

  // Repository
  sl.registerLazySingleton<AvailabilityRepository>(
      () => AvailabilityRepositoryImpl(networkInfo: sl()));

  //! Features - Credentials
  // Bloc
  sl.registerFactory(() => CredentialsBloc(signIn: sl(), signUp: sl()));

  // Use Cases
  sl.registerLazySingleton(() => SignInWithCredentials(sl()));
  sl.registerLazySingleton(() => SignUpWithCredentials(sl()));

  // Repository
  sl.registerLazySingleton<CredentialsRepository>(
      () => CredentialsRepositoryImpl(networkInfo: sl()));

  //! Features - Customer - Customer Home
  // Bloc
  sl.registerFactory(() => HomeCustomerBloc(
      allCategories: sl(),
      medicalRecords: sl(),
      fromCategories: sl(),
      logOut: sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetAllCategories(sl()));
  sl.registerLazySingleton(() => GetAllMedicalRecords(sl()));
  sl.registerLazySingleton(() => SearchFromCategories(sl()));
  sl.registerLazySingleton(() => LogOutCustomer(sl()));

  // Repository
  sl.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(networkInfo: sl()));

  //! Features - Customer - Categorical Doctors
  // Bloc
  sl.registerFactory(
      () => CategoricalDoctorsBloc(categoricalDoctors: sl(), search: sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetAllCategoricalDoctors(sl()));
  sl.registerLazySingleton(() => SearchFromCategoricalDoctors(sl()));

  // Repository
  sl.registerLazySingleton<CategoricalDoctorsRepository>(
      () => CategoricalDoctorsRepositoryImpl(networkInfo: sl()));

  //! Features - Customer - Add Medical Record
  // Bloc
  sl.registerFactory(() => AddMedicalRecordsBloc(upload: sl()));

  // Use Cases
  sl.registerLazySingleton(() => UploadMedicalRecord(sl()));

  // Repository
  sl.registerLazySingleton<AddMedicalRecordsRepository>(
      () => AddMedicalRecordsRepositoryImpl(networkInfo: sl()));

  //! Features - Doctor - Doctor Complete Profile
  // Bloc
  sl.registerFactory(() => CompleteProfileBloc(
      initData: sl(), saveProfile: sl(), specialties: sl()));

  // Use Cases
  sl.registerLazySingleton(() => LoadInitData(sl()));
  sl.registerLazySingleton(() => SaveCompleteProfile(sl()));
  sl.registerLazySingleton(() => SelectSpecialtiesFromList(sl()));

  // Repository
  sl.registerLazySingleton<CompleteProfileRepository>(
      () => CompleteProfileRepositoryImpl(networkInfo: sl()));

  //! Features - Doctor - Doctor Home
  // Bloc
  sl.registerFactory(() => HomeDoctorBloc(
      doctorAppointments: sl(),
      doctorWallet: sl(),
      doctorProfile: sl(),
      logOut: sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetDoctorAppointments(sl()));
  sl.registerLazySingleton(() => GetDoctorWallet(sl()));
  sl.registerLazySingleton(() => DoctorHome.GetDoctorProfile(sl()));
  sl.registerLazySingleton(() => LogOutDoctor(sl()));

  // Repository
  sl.registerLazySingleton<HomeDoctorRepository>(
      () => HomeDoctorRepositoryImpl(networkInfo: sl()));

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  sl.registerLazySingleton(() => DataConnectionChecker());
}
