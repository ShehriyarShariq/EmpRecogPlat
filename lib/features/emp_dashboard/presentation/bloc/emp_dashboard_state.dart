part of 'emp_dashboard_bloc.dart';

abstract class EmpDashboardState extends Equatable {
  const EmpDashboardState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class Initial extends EmpDashboardState {}

class LoadingFeatured extends EmpDashboardState {}

class LoadedFeatured extends EmpDashboardState {
  final Map<String, List<EmployeeModel>> featured;

  LoadedFeatured(this.featured) : super([featured]);
}

class LoadingLeaderboard extends EmpDashboardState {}

class LoadedLeaderboard extends EmpDashboardState {
  final List<LeaderboardRankerModel> leaderboard;

  LoadedLeaderboard(this.leaderboard) : super([leaderboard]);
}

class LoadingProfile extends EmpDashboardState {}

class LoadedProfile extends EmpDashboardState {
  final EmployeeModel employee;

  LoadedProfile(this.employee) : super([employee]);
}

class Cheering extends EmpDashboardState {}

class Cheered extends EmpDashboardState {
  final Map<String, String> updateMap;

  Cheered({this.updateMap}) : super([updateMap]);
}

class LoggingOut extends EmpDashboardState {}

class LoggedOut extends EmpDashboardState {}

class RankUpdated extends EmpDashboardState {
  final String rank;

  RankUpdated({this.rank}) : super([rank]);
}

class UpdatingSelfRanker extends EmpDashboardState {}

class SelfRankerUpdated extends EmpDashboardState {
  final LeaderboardRankerModel selfRanker;

  SelfRankerUpdated({this.selfRanker}) : super([selfRanker]);
}

class UpdateCheerIcon extends EmpDashboardState {}

class Searching extends EmpDashboardState {}

class Searched extends EmpDashboardState {
  final List<EmployeeModel> queriedEmployees;

  Searched({this.queriedEmployees}) : super([queriedEmployees]);
}

class UpdatingResetTimer extends EmpDashboardState {}

class ResetTimerUpdated extends EmpDashboardState {
  final String timerString;

  ResetTimerUpdated({this.timerString}) : super([timerString]);
}

class Saving extends EmpDashboardState {}

class Saved extends EmpDashboardState {
  final String data, type;

  Saved({this.type, this.data}) : super([data]);
}

class Error extends EmpDashboardState {
  final String message;

  Error({this.message}) : super([message]);
}
