import 'package:elaj/features/customer/home_customer/domain/entities/category.dart';

class AllCategoriesSingleton {
  static final AllCategoriesSingleton _instance =
      AllCategoriesSingleton._internal();

  factory AllCategoriesSingleton() => _instance;

  AllCategoriesSingleton._internal() {
    categories = List<Category>();
  }

  List<Category> categories;
}
