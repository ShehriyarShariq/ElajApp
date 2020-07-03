import 'package:dartz/dartz.dart';
import 'package:elaj/core/error/failures.dart';
import 'package:elaj/features/customer/categorial_doctors/domain/entities/basic_doctor.dart';

abstract class CategoricalDoctorsRepository {
  Future<Either<Failure, List<BasicDoctor>>> getAllCategoricalDoctors(
      String lastFetchedDoctorID, String categoryID);
  Future<Either<Failure, List<BasicDoctor>>> searchFromCategoricalDoctors(
      String searchTerm, List<BasicDoctor> categoricalDoctors);
}
