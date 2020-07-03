part of 'app_feedback_bloc.dart';

abstract class AppFeedbackEvent extends Equatable {
  const AppFeedbackEvent([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class GiveFeedbackEvent extends AppFeedbackEvent {
  final String title, desc;

  GiveFeedbackEvent({this.title, this.desc}) : super([title, desc]);
}
