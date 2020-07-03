import 'package:elaj/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/features/doctor/home_doctor/domain/entities/wallet.dart';
import 'package:elaj/features/doctor/home_doctor/domain/repositories/home_doctor_repository.dart';

class GetDoctorWallet implements UseCase<Wallet, NoParams> {
  HomeDoctorRepository repository;

  GetDoctorWallet(this.repository);

  @override
  Future<Either<Failure, Wallet>> call(NoParams params) async {
    return await repository.getDoctorWallet();
  }
}
