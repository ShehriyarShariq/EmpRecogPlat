import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emp_recog_plat/core/firebase/firebase.dart';
import 'package:emp_recog_plat/core/ui/loading_widget.dart';
import 'package:emp_recog_plat/core/ui/no_glow_scroll_behavior.dart';
import 'package:emp_recog_plat/core/ui/search_bar.dart';
import 'package:emp_recog_plat/core/util/constants.dart';
import 'package:emp_recog_plat/features/emp_dashboard/data/models/emp_model.dart';
import 'package:emp_recog_plat/features/emp_dashboard/domain/repositories/emp_home_repository.dart';
import 'package:emp_recog_plat/features/emp_dashboard/presentation/bloc/emp_dashboard_bloc.dart';
import 'package:emp_recog_plat/features/emp_dashboard/presentation/pages/emp_dashboard.dart';
import 'package:emp_recog_plat/features/emp_dashboard/presentation/pages/emp_profile.dart';
import 'package:emp_recog_plat/features/emp_dashboard/presentation/pages/emp_search.dart';
import 'package:emp_recog_plat/features/emp_dashboard/presentation/widgets/featured_item_widget.dart';
import 'package:emp_recog_plat/features/notifications/presentation/pages/notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../injection_container.dart';

class EmployeeHome extends StatefulWidget {
  final Function goToProfileFunc;

  const EmployeeHome({Key key, this.goToProfileFunc}) : super(key: key);

  @override
  _EmployeeHomeState createState() => _EmployeeHomeState();
}

class _EmployeeHomeState extends State<EmployeeHome> {
  EmpDashboardBloc _bloc, _rankUpdateBloc, _featuredLoaderBloc;

  StreamSubscription _rankStreamSubscription;

  EmployeeModel _employee;
  Map<String, List<EmployeeModel>> _featured;
  List<String> _featuredTraits;
  String _rank;

  bool _wasDisconnected = false;

  @override
  void initState() {
    super.initState();

    _rankUpdateBloc = sl<EmpDashboardBloc>();
    _featuredLoaderBloc = sl<EmpDashboardBloc>();
    _bloc = sl<EmpDashboardBloc>();
    _bloc.add(LoadProfileEvent(
        func: sl<EmployeeHomeRepository>().getCurrentUserDetails));
    _featuredLoaderBloc.add(LoadFeaturedEmpEvent(
        func: sl<EmployeeHomeRepository>().getFeaturedEmployees));
  }

  @override
  void dispose() {
    _rankStreamSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return OfflineBuilder(
      connectivityBuilder: (context, connectivity, child) {
        final bool connected = connectivity != ConnectivityResult.none;

        if (connected) {
          if (_rankStreamSubscription == null) {
            getRankStream(_handleRankUpdate, context)
                .then((sub) => _rankStreamSubscription = sub);
          }

          if (_wasDisconnected) {
            _wasDisconnected = false;
            _bloc.add(LoadProfileEvent(
                func: sl<EmployeeHomeRepository>().getCurrentUserDetails));
            _featuredLoaderBloc.add(LoadFeaturedEmpEvent(
                func: sl<EmployeeHomeRepository>().getFeaturedEmployees));
          }
        } else {
          _wasDisconnected = true;

          _rank = sl<EmployeeHomeRepository>().getCachedRank();
        }

        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              toolbarHeight: 80,
              titleSpacing: 0,
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    connected
                        ? SearchBarWidget(
                            controller: TextEditingController(),
                            hintText: "Search for Employee",
                            isDisabled: true,
                            func: () async {
                              final result = await showSearch(
                                  context: context, delegate: EmployeeSearch());

                              if (result != null) {
                                if (result !=
                                    FirebaseInit.auth.currentUser.uid) {
                                  bool isRefresh = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => EmployeeProfile(
                                                id: result,
                                              )));

                                  if (isRefresh)
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                EmployeeDashboard()));
                                } else {
                                  widget.goToProfileFunc();
                                }
                              }
                            },
                          )
                        : Container(),
                    Material(
                      color: Color.fromRGBO(242, 242, 242, 1),
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width *
                              1.1 *
                              0.18 *
                              0.215),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.width *
                                1.1 *
                                0.18 *
                                0.215),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => NotificationList()));
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: MediaQuery.of(context).size.width *
                              1.1 *
                              0.18 *
                              0.215,
                          child: Icon(
                            Icons.notifications_none,
                            color: Color.fromRGBO(27, 94, 121, 1),
                            size: MediaQuery.of(context).size.width *
                                0.87 *
                                0.18 *
                                0.37,
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
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  BlocBuilder(
                    cubit: _bloc,
                    builder: (context, state) {
                      if (state is LoadedProfile) {
                        _employee = state.employee;

                        print(_employee.imageURL);
                      }

                      return SizedBox(
                        width: MediaQuery.of(context).size.width - 30,
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.25,
                              height: MediaQuery.of(context).size.width * 0.25,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.05),
                                border: _employee?.imageURL != null
                                    ? Border.all(width: 0)
                                    : Border.all(
                                        color: Colors.black.withOpacity(0.2),
                                        width: 2),
                                borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.width * 0.125),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: _employee?.imageURL != null
                                  ? CachedNetworkImage(
                                      imageUrl: _employee.imageURL,
                                      placeholder: (context, _) =>
                                          Image.asset("imgs/user.png"),
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset("imgs/user.png"),
                            ),
                            Flexible(
                              flex: 4,
                              child: Container(
                                margin:
                                    const EdgeInsets.only(left: 5, right: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _employee == null
                                        ? Shimmer.fromColors(
                                            child: Container(
                                              height: 17,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                            ),
                                            baseColor:
                                                Colors.grey.withOpacity(0.1),
                                            highlightColor:
                                                Colors.grey.withOpacity(0.2),
                                          )
                                        : Text(
                                            _employee.name,
                                            style: TextStyle(fontSize: 18),
                                          ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    _employee == null
                                        ? Shimmer.fromColors(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    height: 30,
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount: 3,
                                                      itemBuilder:
                                                          (context, index) =>
                                                              Container(
                                                        width: 30,
                                                        height: 30,
                                                        margin: const EdgeInsets
                                                            .only(right: 10),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            baseColor:
                                                Colors.grey.withOpacity(0.1),
                                            highlightColor:
                                                Colors.grey.withOpacity(0.2))
                                        : Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  height: 30,
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        _employee.badges != null
                                                            ? _employee
                                                                .badges.length
                                                            : 0,
                                                    itemBuilder:
                                                        (context, index) =>
                                                            Container(
                                                      width: 40,
                                                      height: 40,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 10),
                                                      child: FadeInImage(
                                                        image: NetworkImage(
                                                            _employee
                                                                .badges[index]),
                                                        placeholder: AssetImage(
                                                            "imgs/badge_placeholder.png"),
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Rank",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black.withOpacity(0.6)),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    SizedBox(
                                      child: BlocBuilder(
                                        cubit: _rankUpdateBloc,
                                        builder: (context, state) {
                                          if (state is RankUpdated) {
                                            _rank = state.rank;
                                          }

                                          return FittedBox(
                                            child: Text(
                                              _rank ?? "N/A",
                                              style: TextStyle(fontSize: 32),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Featured",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black.withOpacity(0.8),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: GestureDetector(
                              onTap: () {
                                _featuredLoaderBloc.add(LoadFeaturedEmpEvent(
                                    func: sl<EmployeeHomeRepository>()
                                        .getFeaturedEmployees));
                              },
                              child: Icon(
                                Icons.refresh,
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                    ],
                  ),
                  Expanded(
                    child: BlocBuilder(
                      cubit: _featuredLoaderBloc,
                      builder: (context, state) {
                        if (state is LoadingFeatured ||
                            state is Error ||
                            state is Initial) {
                          return LoadingWidget();
                        } else if (state is LoadedFeatured) {
                          _featured = state.featured;

                          _featuredTraits = _featured.keys.toList();
                          _featuredTraits.remove('global');
                        }

                        return _buildFeatured();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      child: Container(),
    );
  }

  ScrollConfiguration _buildFeatured() {
    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    'Global Rankings',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                if (_featured == null ||
                    (_featured != null && _featured.containsKey("global"))) ...[
                  if (_featured.containsKey('global')) ...[
                    FeaturedItemWidget(
                      position: '1st',
                      employee: _featured['global'][0],
                    ),
                    if (_featured == null ||
                        _featured['global'].length > 1) ...[
                      Row(
                        children: [
                          Expanded(
                            child: FeaturedItemWidget(
                              position: '2nd',
                              isBig: false,
                              employee: _featured['global'][1],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: _featured['global'].length > 2
                                ? FeaturedItemWidget(
                                    position: '3rd',
                                    isBig: false,
                                    employee: _featured['global'][2],
                                  )
                                : Container(),
                          ),
                        ],
                      ),
                    ]
                  ],
                  Divider(),
                  SizedBox(
                    height: 20,
                  ),
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 35),
                    child: Center(
                      child: Text(
                        "None",
                      ),
                    ),
                  )
                ],
                Center(
                  child: Text(
                    'Categorical Rankings',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                if (_featuredTraits.length > 0) ...[
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: (_featuredTraits.length / 2).ceil(),
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: FeaturedItemWidget(
                              position: '1st',
                              isBig: false,
                              title: Constant
                                  .TRAIT_LABELS[_featuredTraits[index * 2]],
                              employee: _featured[_featuredTraits[index * 2]]
                                  [0],
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: (index * 2) + 1 < _featuredTraits.length
                                ? FeaturedItemWidget(
                                    position: '1st',
                                    isBig: false,
                                    title: Constant.TRAIT_LABELS[
                                        _featuredTraits[(index * 2) + 1]],
                                    employee: _featured[
                                        _featuredTraits[(index * 2) + 1]][0],
                                  )
                                : Container(),
                          )
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Center(
                      child: Text(
                        "None",
                      ),
                    ),
                  )
                ],

                // Row(
                //   children: [
                //     if (_featured.containsKey('teamwork')) ...[
                //       Expanded(
                //         child: FeaturedItemWidget(
                //           position: '1st',
                //           isBig: false,
                //           title: "Teamwork",
                //           employee: _featured['teamwork'][0],
                //         ),
                //       ),
                //       SizedBox(
                //         width: 15,
                //       ),
                //     ],
                //     Expanded(
                //       child: FeaturedItemWidget(
                //         position: '1st',
                //         isBig: false,
                //         title: "Test",
                //       ),
                //     )
                //   ],
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                // Row(
                //   children: [
                //     Expanded(
                //       child: FeaturedItemWidget(
                //         position: '1st',
                //         isBig: false,
                //         title: "Test",
                //       ),
                //     ),
                //     SizedBox(
                //       width: 15,
                //     ),
                //     Expanded(
                //       child: FeaturedItemWidget(
                //         position: '1st',
                //         isBig: false,
                //         title: "Test",
                //       ),
                //     )
                //   ],
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                // Row(
                //   children: [
                //     Expanded(
                //       child: FeaturedItemWidget(
                //         position: '1st',
                //         isBig: false,
                //         title: "Test",
                //       ),
                //     ),
                //     SizedBox(
                //       width: 15,
                //     ),
                //     Expanded(
                //       child: Container(),
                //     )
                //   ],
                // )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<StreamSubscription<Event>> getRankStream(
      void onData(context, String rank), context) async {
    StreamSubscription<Event> rankStreamSub = FirebaseInit.dbRef
        .child(
            "monthly_temp/ranking/global/${FirebaseInit.auth.currentUser.uid}")
        .onValue
        .listen((event) {
      onData(
          context,
          event.snapshot.value != null
              ? (event.snapshot.value + 1).toString()
              : "N/A");
    }, onError: (e) {
      print("ERRORRR");
    });

    return rankStreamSub;
  }

  _handleRankUpdate(context, String rank) {
    sl<EmployeeHomeRepository>().cacheRank(rank);
    _rankUpdateBloc.add(UpdateRankEvent(rank: rank));
  }
}
