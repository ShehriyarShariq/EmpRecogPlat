import 'package:emp_recog_plat/core/ui/loading_widget.dart';
import 'package:emp_recog_plat/core/ui/no_glow_scroll_behavior.dart';
import 'package:emp_recog_plat/features/notifications/data/model/notification_model.dart';
import 'package:emp_recog_plat/features/notifications/domain/repository/notifications_repository.dart';
import 'package:emp_recog_plat/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:emp_recog_plat/features/notifications/presentation/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';

import '../../../../injection_container.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({Key key}) : super(key: key);

  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  ScrollController _scrollController;
  NotificationBloc _bloc;

  List<NotificationModel> _notifications;

  @override
  void initState() {
    super.initState();

    _bloc = sl<NotificationBloc>();

    _bloc.add(LoadNotificationsEvent(
        func: sl<NotificationsRepository>().getUserNotifications));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            titleSpacing: 10,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.chevron_left,
                        size: MediaQuery.of(context).size.width *
                            0.87 *
                            0.18 *
                            0.37,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    "Notifications",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: OfflineBuilder(
            connectivityBuilder: (context, connectivity, child) {
              final bool connected = connectivity != ConnectivityResult.none;

              return Container(
                child: connected
                    ? Column(
                        children: [
                          Expanded(
                            child: BlocBuilder(
                              cubit: _bloc,
                              builder: (context, state) {
                                if (state is Loading || state is Error) {
                                  return LoadingWidget();
                                } else if (state is Loaded) {
                                  _notifications = state.notifications;
                                }

                                if (_notifications.length == 0) {
                                  return Center(
                                    child: Text("No Notifications Available"),
                                  );
                                }

                                return _buildBody(context);
                              },
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Text(
                          "Please connect to the internet\nto view your notifications",
                          textAlign: TextAlign.center,
                        ),
                      ),
              );
            },
            child: Container(),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.87,
        child: ScrollConfiguration(
          behavior: NoGlowScrollBehavior(),
          child: Scrollbar(
            child: ListView.builder(
              controller: _scrollController,
              itemBuilder: (context, index) {
                return TextWidget(txt: _notifications[index].message);
              },
              itemCount: _notifications.length,
            ),
          ),
        ),
      ),
    );
  }
}
