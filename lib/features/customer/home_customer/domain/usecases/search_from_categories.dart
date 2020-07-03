import 'package:elaj/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/core/util/params.dart';
import 'package:elaj/features/customer/home_customer/domain/entities/category.dart';
import 'package:elaj/features/customer/home_customer/domain/repositories/home_repository.dart';

class SearchFromCategories implements UseCase<List<Category>, SearchParams> {
  HomeRepository repository;

  SearchFromCategories(this.repository);

  @override
  Future<Either<Failure, List<Category>>> call(SearchParams params) async {
    return await repository.searchFromCategories(
        params.searchTerm, params.list);
  }
}
