import 'package:auto_size_text/auto_size_text.dart';
import 'package:emp_recog_plat/core/ui/no_glow_scroll_behavior.dart';
import 'package:emp_recog_plat/features/credentials/presentation/pages/sign_in.dart';
import 'package:emp_recog_plat/features/splash/domain/repositories/splash_repository.dart';
import 'package:emp_recog_plat/features/splash/presentation/widgets/onboarding_navigation_btn_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../injection_container.dart';

class Onboarding extends StatefulWidget {
  Onboarding({Key key}) : super(key: key);

  @override
  _OnboardingState createState() => new _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(microseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: 8.0,
      decoration: BoxDecoration(
          color: isActive ? Colors.white : Color(0xFFC7DEE5),
          borderRadius: BorderRadius.all(Radius.circular(100))),
    );
  }

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.lightBlueAccent.withOpacity(0.2),
        child: SafeArea(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: OnboardingNavBtnWidget(
                    fun: () {
                      sl<SplashRepository>().setIsNewUser();

                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => SignInBodyWidget()),
                          ModalRoute.withName('/'));
                    },
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1139),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.04),
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.92,
                          height:
                              MediaQuery.of(context).size.width * 0.92 * 0.333,
                          child: AutoSizeText(
                            "You can cheer your peers by going to their profile.",
                            maxLines: 4,
                            minFontSize: 20,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.92,
                          height:
                              MediaQuery.of(context).size.width * 0.92 * 0.333,
                          child: AutoSizeText(
                            "You can cheer on different traits like teamwork, leadership, etc...",
                            maxLines: 4,
                            minFontSize: 20,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.92,
                          height:
                              MediaQuery.of(context).size.width * 0.92 * 0.333,
                          child: AutoSizeText(
                            "There is a leaderboard which shows most cheered people for the particular month.",
                            maxLines: 4,
                            minFontSize: 20,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.92,
                          height:
                              MediaQuery.of(context).size.width * 0.92 * 0.333,
                          child: AutoSizeText(
                            "Happy Cheering!!!",
                            maxLines: 4,
                            minFontSize: 20,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
