import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:emp_recog_plat/features/emp_dashboard/data/models/emp_model.dart';
import 'package:emp_recog_plat/features/emp_dashboard/data/models/leaderboard_ranker_model.dart';
import 'package:equatable/equatable.dart';

part 'emp_dashboard_event.dart';
part 'emp_dashboard_state.dart';

class EmpDashboardBloc extends Bloc<EmpDashboardEvent, EmpDashboardState> {
  EmpDashboardBloc() : super(Initial());

  @override
  Stream<EmpDashboardState> mapEventToState(
    EmpDashboardEvent event,
  ) async* {
    if (event is LoadFeaturedEmpEvent) {
      yield LoadingFeatured();
      final failureOrFeatured = await event.func();
      yield failureOrFeatured.fold(
          (failure) => Error(), (featured) => LoadedFeatured(featured));
    } else if (event is LoadLeaderboardEvent) {
      yield LoadingLeaderboard();
    } else if (event is UpdateLeaderboardEvent) {
      yield LoadingLeaderboard();
      yield LoadedLeaderboard(event.leaderboard);
    } else if (event is LoadProfileEvent) {
      yield LoadingProfile();
      final failureOrEmployee = await event.func();
      yield failureOrEmployee.fold(
          (failure) => Error(), (employee) => LoadedProfile(employee));
    } else if (event is LogOutEmpEvent) {
      yield LoggingOut();
      final failureOrSuccess = await event.func();
      yield failureOrSuccess.fold(
          (failure) => Error(message: "Failed to Logout"),
          (success) => LoggedOut());
    } else if (event is CheerForEmpEvent) {
      yield Cheering();
      final failureOrSuccess = await event.func();
      yield failureOrSuccess.fold(
          (failure) => Error(message: "Failed to Cheer"),
          (success) => Cheered(updateMap: success));
    } else if (event is UpdateRankEvent) {
      yield RankUpdated(rank: event.rank);
    } else if (event is UpdateCheerIconEvent) {
      yield UpdateCheerIcon();
    } else if (event is UpdateSelfRankerEvent) {
      yield UpdatingSelfRanker();
      yield SelfRankerUpdated(selfRanker: event.selfRanker);
    } else if (event is LoadQueriedEmployees) {
      yield Searching();
      final failureOrSearched = await event.func();
      yield failureOrSearched.fold(
          (failure) => Error(message: "No employees found"),
          (success) => Searched(queriedEmployees: success));
    } else if (event is UpdateResetTimerEvent) {
      yield UpdatingResetTimer();
      yield ResetTimerUpdated(timerString: event.timerString);
    } else if (event is UploadEmployeeImageEvent) {
      yield Saving();
      final failureOrSaved = await event.func();
      yield failureOrSaved.fold((failure) => Error(),
          (success) => Saved(type: "image", data: success));
    } else if (event is UpdateEmployeeAboutEvent) {
      yield Saving();
      final failureOrSaved = await event.func();
      yield failureOrSaved.fold((failure) => Error(),
          (success) => Saved(type: "about", data: success));
    }
  }
}
