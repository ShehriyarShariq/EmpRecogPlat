import 'dart:async';

import 'package:emp_recog_plat/core/firebase/firebase.dart';
import 'package:emp_recog_plat/core/ui/loading_widget.dart';
import 'package:emp_recog_plat/core/ui/no_glow_scroll_behavior.dart';
import 'package:emp_recog_plat/features/admin_dashboard/data/models/log_details.dart';
import 'package:emp_recog_plat/features/admin_dashboard/presentation/bloc/admin_dashboard_bloc.dart';
import 'package:emp_recog_plat/features/credentials/presentation/pages/sign_in.dart';
import 'package:emp_recog_plat/features/emp_dashboard/domain/repositories/emp_profile_repository.dart';
import 'package:emp_recog_plat/features/emp_dashboard/presentation/bloc/emp_dashboard_bloc.dart';
import 'package:emp_recog_plat/injection_container.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ui/overlay_loader.dart' as OverlayLoader;

class AdminActivityLog extends StatefulWidget {
  @override
  _AdminActivityLogState createState() => _AdminActivityLogState();
}

class _AdminActivityLogState extends State<AdminActivityLog> {
  EmpDashboardBloc _logOutBloc;
  AdminDashboardBloc _bloc;

  List<LogDetails> _activityLog = [];

  StreamSubscription _logStreamSubscription;

  @override
  void initState() {
    super.initState();

    _bloc = sl<AdminDashboardBloc>();
    _logOutBloc = sl<EmpDashboardBloc>();
  }

  @override
  void dispose() {
    _logStreamSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_logStreamSubscription == null)
      getLogStream(_handleLogUpdate, context)
          .then((sub) => _logStreamSubscription = sub);

    return BlocListener(
      cubit: _logOutBloc,
      listener: (context, state) {
        if (state is LoggedOut) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => SignInBodyWidget(),
            ),
          );
        }
      },
      child: BlocBuilder(
        cubit: _logOutBloc,
        builder: (context, state) {
          if (state is LoggingOut) {
            return Scaffold(
              body: OverlayLoader.Overlay(),
            );
          }

          return _buildBody(context);
        },
      ),
    );
  }

  Container _buildBody(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            titleSpacing: 0,
            backgroundColor: Colors.white,
            elevation: 0,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(5),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(5),
                      onTap: () {
                        _logOutBloc.add(LogOutEmpEvent(
                            func: sl<EmployeeProfileRepository>()
                                .logOutEmployee));
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Icon(
                              Icons.exit_to_app,
                              color: Color.fromRGBO(27, 94, 121, 1),
                              size: MediaQuery.of(context).size.width *
                                  0.87 *
                                  0.18 *
                                  0.37,
                            ),
                            Text(
                              "LogOut",
                              style: TextStyle(
                                fontSize: 10,
                                color: Color.fromRGBO(27, 94, 121, 1),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width - 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 5, right: 20),
                        child: Column(
                          children: [
                            Text(
                              "Greetings,",
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Shehriyar Shariq",
                              style: TextStyle(fontSize: 26),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Divider(),
                Expanded(
                  child: BlocBuilder(
                    cubit: _bloc,
                    builder: (context, state) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Employee Activity Log",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black.withOpacity(0.6),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Divider(),
                          Expanded(
                            child: ScrollConfiguration(
                              behavior: NoGlowScrollBehavior(),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: _activityLog.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) =>
                                          _buildLogItem(_activityLog[index]),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogItem(LogDetails action) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                top: 10,
                bottom: 8,
                left: 10,
                right: 10,
              ),
              child: Text(
                action.message,
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
            ),
          ),
          Divider(
            indent: 10 + MediaQuery.of(context).size.width * 0.12,
            endIndent: 10 + MediaQuery.of(context).size.width * 0.12,
          ),
        ],
      ),
    );
  }

  Future<StreamSubscription<Event>> getLogStream(
      void onData(context, LogDetails action), context) async {
    return FirebaseInit.dbRef
        .child("activity_log")
        .onChildAdded
        .listen((event) {
      if (event.snapshot.value != null) {
        onData(
            context,
            LogDetails.fromJson(
                Map<String, dynamic>.from(event.snapshot.value)));
      }
    });
  }

  _handleLogUpdate(context, LogDetails action) {
    _activityLog = [action, ..._activityLog];
    _bloc.add(UpdateLogEvent());
  }
}
