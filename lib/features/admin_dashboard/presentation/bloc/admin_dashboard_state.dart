part of 'admin_dashboard_bloc.dart';

abstract class AdminDashboardState extends Equatable {
  const AdminDashboardState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class Initial extends AdminDashboardState {}

class UpdatingLog extends AdminDashboardState {}

class UpdatedLog extends AdminDashboardState {
  final LogDetails action;

  UpdatedLog({this.action}) : super([action]);
}
