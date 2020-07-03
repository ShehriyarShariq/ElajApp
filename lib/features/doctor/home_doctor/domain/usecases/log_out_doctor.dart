import 'package:elaj/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/features/doctor/home_doctor/domain/repositories/home_doctor_repository.dart';

class LogOutDoctor implements UseCase<bool, NoParams> {
  HomeDoctorRepository repository;

  LogOutDoctor(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.logOut();
  }
}
