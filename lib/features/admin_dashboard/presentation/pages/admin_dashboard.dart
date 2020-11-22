import 'package:emp_recog_plat/features/admin_dashboard/presentation/pages/admin_leaderboard.dart';
import 'package:emp_recog_plat/features/emp_dashboard/presentation/pages/emp_leaderboards.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'admin_activity_log.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  PageController _pageController;
  int _page = 0;

  List icons = [
    Icons.filter_frames,
    Icons.equalizer,
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: [
          AdminActivityLog(),
          EmployeeLeaderboard(
            isAdmin: true,
          ),
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
            SizedBox(width: 7),
          ],
        ),
        color: Theme.of(context).primaryColor.withOpacity(.8),
        shape: CircularNotchedRectangle(),
      ),
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
