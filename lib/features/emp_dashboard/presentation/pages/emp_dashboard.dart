import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:emp_recog_plat/core/network/network_connection_updates.dart';
import 'package:emp_recog_plat/features/emp_dashboard/presentation/pages/emp_home.dart';
import 'package:emp_recog_plat/features/emp_dashboard/presentation/pages/emp_leaderboards.dart';
import 'package:emp_recog_plat/features/emp_dashboard/presentation/pages/emp_profile.dart';
import 'package:emp_recog_plat/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_offline/flutter_offline.dart';

class EmployeeDashboard extends StatefulWidget {
  @override
  _EmployeeDashboardState createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {
  PageController _pageController;
  int _page = 0;

  double _connectivityStatusBarHeight = 30;

  List icons = [
    Icons.home,
    Icons.equalizer,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return OfflineBuilder(
      connectivityBuilder: (context, connectivity, child) {
        final bool connected = connectivity != ConnectivityResult.none;

        _connectivityStatusBarHeight = !connected ? 30 : 0;

        return Material(
          child: Column(
            children: [
              Expanded(
                child: Scaffold(
                  backgroundColor: Colors.white,
                  body: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: onPageChanged,
                    children: [
                      EmployeeHome(goToProfileFunc: () {
                        _pageController.jumpToPage(2);
                      }),
                      EmployeeLeaderboard(),
                      EmployeeProfile(),
                    ],
                  ),
                  bottomNavigationBar: BottomAppBar(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(width: 7),
                        buildTabIcon(0),
                        buildTabIcon(1),
                        buildTabIcon(2),
                        SizedBox(width: 7),
                      ],
                    ),
                    color: Theme.of(context).primaryColor.withOpacity(.8),
                    shape: CircularNotchedRectangle(),
                  ),
                  floatingActionButtonAnimator:
                      FloatingActionButtonAnimator.scaling,
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerDocked,
                  floatingActionButton: FloatingActionButton(
                    elevation: 10.0,
                    backgroundColor: _page == 1
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    child: Icon(
                      Icons.equalizer,
                      color: _page == 1
                          ? Colors.white
                          : Colors.black.withOpacity(0.4),
                    ),
                    onPressed: () => _pageController.jumpToPage(1),
                  ),
                ),
              ),
              AnimatedContainer(
                curve: connected ? Curves.easeOut : Curves.easeIn,
                duration: Duration(milliseconds: connected ? 2000 : 500),
                width: MediaQuery.of(context).size.width,
                color: connected ? Colors.green : Colors.black,
                alignment: Alignment.center,
                height: _connectivityStatusBarHeight,
                child: Text(
                  connected ? "Online" : "Not Connected",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 13,
                  ),
                ),
              )
            ],
          ),
        );
      },
      child: Container(),
    );
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  buildTabIcon(int index) {
    if (index == 1) {
      return Opacity(
        opacity: 0,
        child: IconButton(
          icon: Icon(
            icons[index],
            size: 24.0,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: null,
        ),
      );
    } else {
      return IconButton(
        icon: Icon(
          icons[index],
          size: 24.0,
        ),
        color: _page == index ? Colors.white : Colors.black.withOpacity(0.4),
        onPressed: () => _pageController.jumpToPage(index),
      );
    }
  }
}
