import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:emp_recog_plat/core/usecases/usecases.dart';
import 'package:equatable/equatable.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  // CheckCurrentUser checkCurrentUser;

  SplashBloc() : super(Initial());

  @override
  Stream<SplashState> mapEventToState(
    SplashEvent event,
  ) async* {
    if (event is CheckCurrentUserEvent) {
      final failureOrUser = await event.func();
      yield failureOrUser.fold(
          (failure) => Error(), (map) => Success(map: map));
    }
  }
}
