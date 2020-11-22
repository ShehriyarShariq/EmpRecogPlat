import 'dart:async';

import 'package:emp_recog_plat/features/emp_dashboard/presentation/bloc/emp_dashboard_bloc.dart';
import 'package:emp_recog_plat/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntp/ntp.dart';

class ResetTimerWidget extends StatefulWidget {
  @override
  _ResetTimerWidgetState createState() => _ResetTimerWidgetState();
}

class _ResetTimerWidgetState extends State<ResetTimerWidget> {
  EmpDashboardBloc _bloc;
  String _timer = '';

  Timer _leaderboardResetRemainingTimeTimer;

  @override
  void initState() {
    super.initState();

    _bloc = sl<EmpDashboardBloc>();

    _startleaderboardResetRemainingTimeTimer();
  }

  @override
  void dispose() {
    _leaderboardResetRemainingTimeTimer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        cubit: _bloc,
        builder: (context, state) {
          if (state is ResetTimerUpdated) {
            _timer = state.timerString;

            return Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Center(
                  child: Text(
                _timer == "" ? "" : "Resets in $_timer",
                style: TextStyle(
                    fontSize: 14, color: Colors.black.withOpacity(0.6)),
              )),
            );
          }

          return Container();
        });
  }

  Future<void> _startleaderboardResetRemainingTimeTimer() async {
    const oneSec = const Duration(seconds: 1);
    DateTime startTime = DateTime.now();
    await NTP.getNtpOffset().then((int ntpOffset) {
      startTime = startTime.add(Duration(milliseconds: ntpOffset));
    });
    DateTime endTime = DateTime(startTime.year, startTime.month + 1, 1);

    _leaderboardResetRemainingTimeTimer = new Timer.periodic(oneSec, (timer) {
      if (endTime.difference(startTime).inSeconds < 1) {
        _leaderboardResetRemainingTimeTimer.cancel();
        _bloc.add(UpdateResetTimerEvent(timerString: "00:00:00"));
      } else {
        startTime = startTime.add(Duration(seconds: 1));
        Duration remTime = endTime.difference(startTime);
        _bloc.add(UpdateResetTimerEvent(
            timerString:
                "${remTime.inDays} days and ${remTime.inHours.remainder(24).toString()}:${remTime.inMinutes.remainder(60).toString()}:${remTime.inSeconds.remainder(60).toString()}"));
      }
    });
  }
}
