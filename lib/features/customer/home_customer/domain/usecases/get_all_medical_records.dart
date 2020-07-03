import 'package:dartz/dartz.dart';
import 'package:elaj/core/error/failures.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/features/customer/add_medical_record/domain/entities/medical_record.dart';
import 'package:elaj/features/customer/home_customer/domain/repositories/home_repository.dart';

class GetAllMedicalRecords implements UseCase<List<MedicalRecord>, NoParams> {
  HomeRepository repository;

  GetAllMedicalRecords(this.repository);

  @override
  Future<Either<Failure, List<MedicalRecord>>> call(NoParams params) async {
    return await repository.getAllMedicalRecords();
  }
}
