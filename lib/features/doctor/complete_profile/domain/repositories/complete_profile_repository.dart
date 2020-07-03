import 'package:dartz/dartz.dart';
import 'package:elaj/core/error/failures.dart';
import 'package:elaj/features/customer/home_customer/domain/entities/category.dart';
import 'package:elaj/features/doctor/complete_profile/domain/entities/complete_doctor.dart';

abstract class CompleteProfileRepository {
  Future<Either<Failure, Map<String, dynamic>>> loadInitData();
  Future<Either<Failure, bool>> saveCompleteProfile(
      CompleteDoctor completeDoctor);
  Future<Either<Failure, List<Category>>> searchFromCategories(
      String searchTerm, List<Category> categories);
}
