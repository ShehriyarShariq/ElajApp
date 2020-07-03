part of 'app_feedback_bloc.dart';

abstract class AppFeedbackState extends Equatable {
  const AppFeedbackState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class Initial extends AppFeedbackState {}

class Processing extends AppFeedbackState {}

class Success extends AppFeedbackState {
  final bool isSuccess;

  Success({this.isSuccess}) : super([isSuccess]);
}

class Error extends AppFeedbackState {}
