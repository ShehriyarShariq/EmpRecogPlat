import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:emp_recog_plat/core/error/failures.dart';
import 'package:emp_recog_plat/features/credentials/data/models/credentials_model.dart';
import 'package:equatable/equatable.dart';

part 'credentials_event.dart';
part 'credentials_state.dart';

class CredentialsBloc extends Bloc<CredentialsEvent, CredentialsState> {
  CredentialsBloc() : super(Initial());

  @override
  Stream<CredentialsState> mapEventToState(
    CredentialsEvent event,
  ) async* {
    if (event is LoginWithCredentialsEvent) {
      yield Processing();
      final failureOrSuccess = await event.func();
      yield failureOrSuccess.fold((failure) => Error(failure.errorMsg),
          (success) => Success(isAdmin: success));
    } else if (event is RegisterUserEvent) {
      yield Processing();
      final failureOrSuccess = await event.func();
      yield failureOrSuccess.fold(
          (failure) => Error(failure.errorMsg), (success) => Registered());
    }
  }
}
