part of 'complete_profile_bloc.dart';

abstract class CompleteProfileState extends Equatable {
  const CompleteProfileState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class Initial extends CompleteProfileState {}

class Loading extends CompleteProfileState {}

class Loaded extends CompleteProfileState {
  final Map<String, dynamic> initData;

  Loaded({this.initData}) : super([initData]);
}

class Fetching extends CompleteProfileState {}

class FetchingChildFieldData extends CompleteProfileState {
  final String parentType;

  FetchingChildFieldData({this.parentType}) : super([parentType]);
}

class GoToNextPage extends CompleteProfileState {}

class GoToPrevPage extends CompleteProfileState {}

class Saved extends CompleteProfileState {
  final bool isSaved;

  Saved({this.isSaved}) : super([isSaved]);
}

class FetchedChildFieldData extends CompleteProfileState {
  final int parentIndex;
  final String type, parentType;
  final dynamic property;

  FetchedChildFieldData(
      {this.parentType, this.parentIndex, this.type, this.property})
      : super([parentType, parentIndex, type, property]);
}

class Error extends CompleteProfileState {}

class LoadingCategories extends CompleteProfileState {}

class LoadedCategories extends CompleteProfileState {
  final List<Category> categories;

  LoadedCategories({this.categories}) : super([categories]);
}

class SearchedCategories extends CompleteProfileState {
  final List<Category> queriedCategories;

  SearchedCategories({this.queriedCategories}) : super([queriedCategories]);
}
