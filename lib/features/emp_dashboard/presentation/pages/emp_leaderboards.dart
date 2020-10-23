import 'package:emp_recog_plat/core/ui/no_glow_scroll_behavior.dart';
import 'package:emp_recog_plat/core/util/constants.dart';
import 'package:emp_recog_plat/features/emp_dashboard/presentation/widgets/leaderboard_rankers_widget.dart';
import 'package:emp_recog_plat/features/emp_dashboard/presentation/widgets/reset_timer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmployeeLeaderboard extends StatefulWidget {
  @override
  _EmployeeLeaderboardState createState() => _EmployeeLeaderboardState();
}

class _EmployeeLeaderboardState extends State<EmployeeLeaderboard> {
  bool _isGlobal = true;
  String _selectedCategory;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.equalizer,
                    size: 38,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      "Leaderboards",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ],
              ),
            ),
            ResetTimerWidget(),
            SizedBox(
              height: 25,
            ),
            _buildTabToggler(),
            if (!_isGlobal) ...[
              SizedBox(height: 20),
              SizedBox(
                height: 45,
                child: InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    _showCategorySelectionDialog();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        border:
                            Border.all(color: Theme.of(context).primaryColor),
                        borderRadius: BorderRadius.circular(3)),
                    child: Center(
                      child: Text(
                        _selectedCategory ?? "Category",
                        style: TextStyle(
                            fontSize: 17,
                            fontFamily: Constant.DEFAULT_FONT,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ),
              )
            ],
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: NoGlowScrollBehavior(),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: LeaderboardRankersWidget(
                                isBig: true, position: "1"),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: LeaderboardRankersWidget(position: "2"),
                          ),
                          Expanded(
                            child: LeaderboardRankersWidget(position: "3"),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Flexible(
                                  fit: FlexFit.tight,
                                  flex: 1,
                                  child: Center(
                                      child: Text(
                                    "Rank",
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.6),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                                ),
                                Flexible(
                                  fit: FlexFit.tight,
                                  flex: 4,
                                  child: Center(
                                      child: Text(
                                    "Name",
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.6),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                                ),
                              ],
                            ),
                            Divider(),
                            ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: 7,
                                itemBuilder: (context, index) =>
                                    _buildListItemWidget(index + 4)),
                            _buildListItemWidget(11, isSelf: true),
                            SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTabToggler() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 45,
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    if (!_isGlobal) {
                      _selectedCategory = null;
                      setState(() {
                        _isGlobal = true;
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: _isGlobal
                            ? Theme.of(context).primaryColor.withOpacity(0.1)
                            : Colors.transparent,
                        border: Border.all(
                            color: _isGlobal
                                ? Theme.of(context).primaryColor
                                : Colors.black.withOpacity(0.4)),
                        borderRadius: BorderRadius.circular(3)),
                    child: Center(
                      child: Text(
                        "Global",
                        style: TextStyle(
                            fontSize: 17,
                            fontFamily: Constant.DEFAULT_FONT,
                            color: _isGlobal
                                ? Theme.of(context).primaryColor
                                : Colors.black.withOpacity(0.4)),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    if (_isGlobal) {
                      _selectedCategory = null;
                      setState(() {
                        _isGlobal = false;
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: !_isGlobal
                            ? Theme.of(context).primaryColor.withOpacity(0.1)
                            : Colors.transparent,
                        border: Border.all(
                            color: !_isGlobal
                                ? Theme.of(context).primaryColor
                                : Colors.black.withOpacity(0.4)),
                        borderRadius: BorderRadius.circular(3)),
                    child: Center(
                      child: Text(
                        "Categorical",
                        style: TextStyle(
                            fontSize: 17,
                            fontFamily: Constant.DEFAULT_FONT,
                            color: !_isGlobal
                                ? Theme.of(context).primaryColor
                                : Colors.black.withOpacity(0.4)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showCategorySelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: ['Test1', 'Test2', 'Test3', 'Test4']
                    .map(
                      (e) => RadioListTile(
                        title: Text(e),
                        value: e,
                        groupValue: _selectedCategory,
                        selected: _selectedCategory == e,
                        activeColor:
                            Theme.of(context).primaryColor.withOpacity(0.6),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                            Navigator.pop(context);
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildListItemWidget(int index, {isSelf = false}) {
    return GestureDetector(
      onTap: () {
        // Navigator.
      },
      child: Container(
        color: isSelf
            ? Theme.of(context).primaryColor.withOpacity(0.6)
            : Colors.transparent,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Center(
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            border: isSelf
                                ? null
                                : Border.all(
                                    color: Theme.of(context).primaryColor,
                                  ),
                            borderRadius: BorderRadius.circular(5),
                            color: isSelf
                                ? Colors.white
                                : Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.6)),
                        child: Center(
                          child: Text(
                            "$index",
                            style: TextStyle(
                              fontSize: 16,
                              color: isSelf
                                  ? Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.6)
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 4,
                    child: Text(
                      isSelf ? "You" : "Shehriyar Shariq",
                      style: TextStyle(
                        fontSize: 16,
                        color: isSelf
                            ? Colors.white
                            : Theme.of(context).primaryColor.withOpacity(0.6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (!isSelf) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Divider(
                  height: 1,
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
