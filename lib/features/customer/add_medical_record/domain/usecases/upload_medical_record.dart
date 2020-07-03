import 'package:dartz/dartz.dart';
import 'package:elaj/core/error/failures.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/core/util/params.dart';
import 'package:elaj/features/customer/add_medical_record/domain/entities/medical_record.dart';
import 'package:elaj/features/customer/add_medical_record/domain/repositories/add_medical_records_repository.dart';
import 'package:elaj/features/customer/home_customer/domain/repositories/home_repository.dart';

class UploadMedicalRecord implements UseCase<bool, MedicalRecordParams> {
  AddMedicalRecordsRepository repository;

  UploadMedicalRecord(this.repository);

  @override
  Future<Either<Failure, bool>> call(MedicalRecordParams params) async {
    return await repository.uploadMedicalRecord(params.record);
  }
}
