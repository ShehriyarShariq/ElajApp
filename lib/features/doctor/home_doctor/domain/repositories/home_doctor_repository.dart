import 'package:dartz/dartz.dart';
import 'package:elaj/core/error/failures.dart';
import 'package:elaj/features/common/all_appointments/domain/entities/basic_appointment.dart';
import 'package:elaj/features/doctor/complete_profile/domain/entities/complete_doctor.dart';
import 'package:elaj/features/doctor/home_doctor/domain/entities/wallet.dart';

abstract class HomeDoctorRepository {
  Future<Either<Failure, Map<DateTime, List<BasicAppointment>>>>
      getDoctorAppointments();
  Future<Either<Failure, Wallet>> getDoctorWallet();
  Future<Either<Failure, CompleteDoctor>> getDoctorProfile();
  Future<Either<Failure, bool>> logOut();
}
