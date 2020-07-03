import 'package:elaj/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/features/customer/home_customer/domain/entities/category.dart';
import 'package:elaj/features/customer/home_customer/domain/repositories/home_repository.dart';

class GetAllCategories implements UseCase<List<Category>, NoParams> {
  HomeRepository repository;

  GetAllCategories(this.repository);

  @override
  Future<Either<Failure, List<Category>>> call(NoParams params) async {
    return await repository.getAllCategories();
  }
}
