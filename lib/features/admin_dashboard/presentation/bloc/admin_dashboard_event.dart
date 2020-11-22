part of 'admin_dashboard_bloc.dart';

abstract class AdminDashboardEvent extends Equatable {
  const AdminDashboardEvent([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class UpdateLogEvent extends AdminDashboardEvent {}
