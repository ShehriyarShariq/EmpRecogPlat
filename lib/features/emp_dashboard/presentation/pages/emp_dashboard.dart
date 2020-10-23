import 'package:emp_recog_plat/features/emp_dashboard/presentation/pages/emp_home.dart';
import 'package:emp_recog_plat/features/emp_dashboard/presentation/pages/emp_leaderboards.dart';
import 'package:emp_recog_plat/features/emp_dashboard/presentation/pages/emp_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmployeeDashboard extends StatefulWidget {
  @override
  _EmployeeDashboardState createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {
  PageController _pageController;
  int _page = 0;

  List icons = [
    Icons.home,
    Icons.equalizer,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      body: SafeArea(
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: [
            EmployeeHome(),
            EmployeeLeaderboard(),
            EmployeeProfile(),
          ],
        ),
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
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 10.0,
        backgroundColor:
            _page == 1 ? Theme.of(context).primaryColor : Colors.white,
        child: Icon(
          Icons.equalizer,
          color: _page == 1 ? Colors.white : Colors.black.withOpacity(0.4),
        ),
        onPressed: () => _pageController.jumpToPage(1),
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
