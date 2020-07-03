import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:elaj/core/error/failures.dart';
import 'package:elaj/features/customer/add_medical_record/domain/entities/medical_record.dart';

abstract class AddMedicalRecordsRepository {
  Future<Either<Failure, bool>> uploadMedicalRecord(
      MedicalRecord record);
}
