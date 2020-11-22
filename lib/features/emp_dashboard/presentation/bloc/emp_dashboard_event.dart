part of 'emp_dashboard_bloc.dart';

abstract class EmpDashboardEvent extends Equatable {
  const EmpDashboardEvent([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class LoadFeaturedEmpEvent extends EmpDashboardEvent {
  final Function func;

  LoadFeaturedEmpEvent({this.func}) : super([func]);
}

class LoadLeaderboardEvent extends EmpDashboardEvent {}

class UpdateLeaderboardEvent extends EmpDashboardEvent {
  final List<LeaderboardRankerModel> leaderboard;

  UpdateLeaderboardEvent({this.leaderboard}) : super([leaderboard]);
}

class LoadProfileEvent extends EmpDashboardEvent {
  final Function func;

  LoadProfileEvent({this.func}) : super([func]);
}

class LogOutEmpEvent extends EmpDashboardEvent {
  final Function func;

  LogOutEmpEvent({this.func}) : super([func]);
}

class CheerForEmpEvent extends EmpDashboardEvent {
  final Function func;

  CheerForEmpEvent({this.func}) : super([func]);
}

class UpdateRankEvent extends EmpDashboardEvent {
  final String rank;

  UpdateRankEvent({this.rank}) : super([rank]);
}

class UpdateSelfRankerEvent extends EmpDashboardEvent {
  final LeaderboardRankerModel selfRanker;

  UpdateSelfRankerEvent({this.selfRanker}) : super([selfRanker]);
}

class UpdateCheerIconEvent extends EmpDashboardEvent {}

class LoadQueriedEmployees extends EmpDashboardEvent {
  final Function func;

  LoadQueriedEmployees({this.func}) : super([func]);
}

class UpdateResetTimerEvent extends EmpDashboardEvent {
  final String timerString;

  UpdateResetTimerEvent({this.timerString}) : super([timerString]);
}

class UploadEmployeeImageEvent extends EmpDashboardEvent {
  final Function func;

  UploadEmployeeImageEvent({this.func}) : super([func]);
}

class UpdateEmployeeAboutEvent extends EmpDashboardEvent {
  final Function func;

  UpdateEmployeeAboutEvent({this.func}) : super([func]);
}
