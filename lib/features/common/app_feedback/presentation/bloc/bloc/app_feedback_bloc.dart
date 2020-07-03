import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:elaj/core/util/params.dart';
import 'package:elaj/features/common/app_feedback/domain/usecases/give_feedback.dart';
import 'package:equatable/equatable.dart';

part 'app_feedback_event.dart';
part 'app_feedback_state.dart';

class AppFeedbackBloc extends Bloc<AppFeedbackEvent, AppFeedbackState> {
  GiveFeedback giveFeedback;

  AppFeedbackBloc({GiveFeedback feedback})
      : assert(feedback != null),
        giveFeedback = feedback;

  @override
  AppFeedbackState get initialState => Initial();

  @override
  Stream<AppFeedbackState> mapEventToState(
    AppFeedbackEvent event,
  ) async* {
    if (event is GiveFeedbackEvent) {
      yield Processing();
      final failureOrSuccess = await giveFeedback(
          AppFeedbackParams(title: event.title, desc: event.desc));
      yield failureOrSuccess.fold(
          (failure) => Error(), (isSuccess) => Success(isSuccess: isSuccess));
    }
  }
}
