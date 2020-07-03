import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:elaj/core/usecases/usecases.dart';
import 'package:elaj/features/common/splash/domain/usecases/check_current_user.dart';
import 'package:equatable/equatable.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  CheckCurrentUser checkCurrentUser;

  SplashBloc({CheckCurrentUser currentUser})
      : assert(currentUser != null),
        checkCurrentUser = currentUser;

  @override
  SplashState get initialState => Initial();

  @override
  Stream<SplashState> mapEventToState(
    SplashEvent event,
  ) async* {
    if (event is CheckCurrentUserEvent) {
      final failureOrUser = await checkCurrentUser(NoParams());
      yield failureOrUser.fold(
          (failure) => Error(), (map) => Success(map: map));
    }
  }
}
