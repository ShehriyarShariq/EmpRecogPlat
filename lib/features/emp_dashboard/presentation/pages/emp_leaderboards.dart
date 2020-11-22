import 'dart:async';

import 'package:emp_recog_plat/core/ui/loading_widget.dart';
import 'package:emp_recog_plat/features/emp_dashboard/domain/repositories/emp_profile_repository.dart';
import 'package:emp_recog_plat/features/emp_dashboard/presentation/bloc/emp_dashboard_bloc.dart';
import 'package:emp_recog_plat/injection_container.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/firebase/firebase.dart';
import '../../../../core/ui/no_glow_scroll_behavior.dart';
import '../../../../core/util/constants.dart';
import '../../data/models/emp_model.dart';
import '../../data/models/leaderboard_ranker_model.dart';
import '../widgets/leaderboard_rankers_widget.dart';
import '../widgets/reset_timer_widget.dart';

class EmployeeLeaderboard extends StatefulWidget {
  final bool isAdmin;

  const EmployeeLeaderboard({Key key, this.isAdmin = false}) : super(key: key);

  @override
  _EmployeeLeaderboardState createState() => _EmployeeLeaderboardState();
}

class _EmployeeLeaderboardState extends State<EmployeeLeaderboard> {
  EmpDashboardBloc _bloc, _selfBloc;

  bool _isGlobal = true, _isSelfRanker = false, _isTopRanker = false;
  String _selectedCategory;

  LeaderboardRankerModel _selfRanker =
      new LeaderboardRankerModel(name: "You", rank: "N/A", cheers: "N/A");

  List<LeaderboardRankerModel> _leaderboard;

  StreamSubscription _leaderboardStreamSubscription;

  @override
  void initState() {
    super.initState();

    _selfBloc = sl<EmpDashboardBloc>();
    _bloc = sl<EmpDashboardBloc>();
    _bloc.add(LoadLeaderboardEvent());
  }

  @override
  Widget build(BuildContext context) {
    if (_leaderboardStreamSubscription == null) {
      getLeaderboardStream(
          _selectedCategory ?? "global", _handleLeaderboardUpdate, context);
    }

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return SafeArea(
      child: Scaffold(
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
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          border:
                              Border.all(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(3)),
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              _selectedCategory != null
                                  ? Constant.TRAIT_LABELS[_selectedCategory]
                                  : "Category",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: Constant.DEFAULT_FONT,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            bottom: 0,
                            right: 10,
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: Theme.of(context).primaryColor,
                              size: 26,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 3,
                    backgroundColor: Colors.green,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "LIVE",
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 10),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: BlocBuilder(
                  cubit: _bloc,
                  builder: (context, state) {
                    if (state is LoadingLeaderboard || state is Initial) {
                      if (_leaderboardStreamSubscription == null)
                        return LoadingWidget();
                    } else if (state is LoadedLeaderboard) {
                      _leaderboard = state.leaderboard;
                      if (!widget.isAdmin)
                        for (int i = 0; i < _leaderboard.length; i++) {
                          if (_leaderboard[i].empID ==
                              FirebaseInit.auth.currentUser.uid) {
                            if (i < 3) {
                              _isTopRanker = true;
                            }

                            _isSelfRanker = true;
                            break;
                          }
                        }
                    }

                    if (!widget.isAdmin) {
                      if (!_isSelfRanker) {
                        getRankStream(_selectedCategory ?? "global",
                            _handleRankUpdate, context);
                      }
                    }

                    return _buildBody();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  ScrollConfiguration _buildBody() {
    print("isSelfRanker: $_isSelfRanker");
    print("isAdmin: ${widget.isAdmin}");
    print("leaderboardSize: ${_leaderboard.length}");
    // print((_isSelfRanker || widget.isAdmin) && _leaderboard.length - 3 <= 0);

    return ScrollConfiguration(
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
                    isBig: true,
                    position: "1",
                    isLocked: _leaderboard.length == 0,
                    ranker: _leaderboard.length == 0 ? null : _leaderboard[0],
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: LeaderboardRankersWidget(
                    position: "2",
                    isLocked: _leaderboard.length < 2,
                    ranker: _leaderboard.length >= 2 ? _leaderboard[1] : null,
                  ),
                ),
                Expanded(
                  child: LeaderboardRankersWidget(
                    position: "3",
                    isLocked: _leaderboard.length < 3,
                    ranker: _leaderboard.length >= 3 ? _leaderboard[2] : null,
                  ),
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
                        child: Text(
                          "Name",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 1,
                        child: Center(
                            child: Text(
                          "Cheers",
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                      ),
                    ],
                  ),
                  Divider(),
                  if (_leaderboard.length - 3 > 0) ...[
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _leaderboard.length - 3,
                        itemBuilder: (context, index) =>
                            _buildListItemWidget(_leaderboard[index + 3])),
                  ],
                  if (!widget.isAdmin && !_isSelfRanker) ...[
                    BlocBuilder(
                      cubit: _selfBloc,
                      builder: (context, state) {
                        if (state is SelfRankerUpdated) {
                          _selfRanker = state.selfRanker;
                        }

                        if (_selfRanker.rank != "N/A")
                          return _buildListItemWidget(_selfRanker,
                              isSelf: true);
                        else
                          return Container();
                      },
                    ),
                  ],
                  if ((_leaderboard.length < 4 && _isTopRanker) ||
                      ((!_isTopRanker &&
                          !_isSelfRanker &&
                          _leaderboard.length < 4))) ...[
                    FittedBox(
                      child: Container(
                        height: 45,
                        margin: const EdgeInsets.only(top: 10),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width - 30,
                        color: Colors.grey.withOpacity(0.4),
                        child: Text(
                          "None",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
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
                      _selectedCategory = Constant.TRAIT_LABELS.keys.first;
                      _leaderboardStreamSubscription = null;
                      _bloc.add(LoadLeaderboardEvent());
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
                children: Constant.TRAIT_LABELS.keys
                    .map(
                      (traitID) => RadioListTile(
                        title: Text(Constant.TRAIT_LABELS[traitID]),
                        value: traitID,
                        groupValue: _selectedCategory,
                        selected: _selectedCategory == traitID,
                        activeColor:
                            Theme.of(context).primaryColor.withOpacity(0.6),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                            _leaderboardStreamSubscription = null;
                            _bloc.add(LoadLeaderboardEvent());
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

  Widget _buildListItemWidget(LeaderboardRankerModel ranker, {isSelf = false}) {
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
                        padding: const EdgeInsets.all(2),
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
                          child: FittedBox(
                            child: Text(
                              ranker.rank,
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
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 4,
                    child: Text(
                      isSelf ? "You" : ranker.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelf
                            ? Colors.white
                            : Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Text(
                      ranker.cheers,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.4),
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

  Future<StreamSubscription<Event>> getRankStream(String type,
      void onData(context, String type, String rank), context) async {
    return FirebaseInit.dbRef
        .child(
            "monthly_temp/ranking/${type == "global" ? "global" : "traits/" + type}/${FirebaseInit.auth.currentUser.uid}")
        .onValue
        .listen((event) {
      onData(
          context,
          type,
          event.snapshot.value != null
              ? (event.snapshot.value + 1).toString()
              : "N/A");
    });
  }

  _handleRankUpdate(context, String type, String rank) {
    _selfRanker.rank = rank;
    FirebaseInit.dbRef
        .child(
            "monthly_temp/employee_achievements/employee_cheers/${FirebaseInit.auth.currentUser.uid}/${type == "global" ? "count" : "traits/" + type}")
        .once()
        .then((snapshot) {
      _selfRanker.cheers = snapshot.value.toString() ?? "N/A";
      sl<EmployeeProfileRepository>().cacheRank(rank);
      if (_selfRanker.cheers != "NA")
        sl<EmployeeProfileRepository>()
            .cacheTypeCheer(type, _selfRanker.cheers);
      _selfBloc.add(UpdateSelfRankerEvent(selfRanker: _selfRanker));
    });
  }

  Future<StreamSubscription<Event>> getLeaderboardStream(
      String type,
      void onData(context, List<LeaderboardRankerModel> leaderboard),
      context) async {
    if (_leaderboardStreamSubscription != null)
      _leaderboardStreamSubscription.cancel();
    return FirebaseInit.dbRef
        .child(
            "monthly_temp/leaderboard/${type == "global" ? "global" : "traits/" + type}")
        .onValue
        .listen((event) {
      onData(
          context,
          event.snapshot.value != null
              ? List<dynamic>.from(event.snapshot.value)
                  .map<LeaderboardRankerModel>((employee) =>
                      LeaderboardRankerModel.fromJson(
                          Map<String, dynamic>.from(employee)))
                  .toList()
              : []);
    });
  }

  _handleLeaderboardUpdate(context, List<LeaderboardRankerModel> leaderboard) {
    _bloc.add(UpdateLeaderboardEvent(leaderboard: leaderboard));
  }
}
