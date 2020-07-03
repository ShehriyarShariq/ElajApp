import 'package:elaj/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/features/doctor/complete_profile/domain/entities/complete_doctor.dart';
import 'package:elaj/features/doctor/home_doctor/domain/repositories/home_doctor_repository.dart';

class GetDoctorProfile implements UseCase<CompleteDoctor, NoParams> {
  HomeDoctorRepository repository;

  GetDoctorProfile(this.repository);

  @override
  Future<Either<Failure, CompleteDoctor>> call(NoParams params) async {
    return await repository.getDoctorProfile();
  }
}
