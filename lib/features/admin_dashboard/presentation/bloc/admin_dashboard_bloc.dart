import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:emp_recog_plat/features/admin_dashboard/data/models/log_details.dart';
import 'package:equatable/equatable.dart';

part 'admin_dashboard_event.dart';
part 'admin_dashboard_state.dart';

class AdminDashboardBloc
    extends Bloc<AdminDashboardEvent, AdminDashboardState> {
  AdminDashboardBloc() : super(Initial());

  @override
  Stream<AdminDashboardState> mapEventToState(
    AdminDashboardEvent event,
  ) async* {
    if (event is UpdateLogEvent) {
      yield UpdatingLog();
      yield UpdatedLog();
    }
  }
}
