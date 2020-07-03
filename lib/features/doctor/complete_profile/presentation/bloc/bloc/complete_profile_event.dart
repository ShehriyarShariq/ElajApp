part of 'complete_profile_bloc.dart';

abstract class CompleteProfileEvent extends Equatable {
  const CompleteProfileEvent([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class LoadInitDataEvent extends CompleteProfileEvent {}

class FetchAllDataEvent extends CompleteProfileEvent {}

class FetchAllChildFieldDataEvent extends CompleteProfileEvent {
  final String parentType;

  FetchAllChildFieldDataEvent({this.parentType}) : super([parentType]);
}

class SaveFetchedDataEvent extends CompleteProfileEvent {
  final dynamic property;
  final String type;
  final int pageNum;

  SaveFetchedDataEvent({this.pageNum, this.property, this.type})
      : super([pageNum, property, type]);
}

class SaveFetchedDataToParentEvent extends CompleteProfileEvent {
  final dynamic property;
  final String type, parentType;
  final int parentIndex;

  SaveFetchedDataToParentEvent(
      {this.parentType, this.parentIndex, this.property, this.type})
      : super([property, type, parentType, parentIndex]);
}

class SearchFromCategoriesEvent extends CompleteProfileEvent {
  final String searchTerm;
  final List<Category> list;

  SearchFromCategoriesEvent(this.searchTerm, this.list)
      : super([searchTerm, list]);
}

class GoToPrevPageEvent extends CompleteProfileEvent {}

class ResetEvent extends CompleteProfileEvent {}
