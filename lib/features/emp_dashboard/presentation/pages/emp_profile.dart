import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emp_recog_plat/core/firebase/firebase.dart';
import 'package:emp_recog_plat/core/ui/loading_widget.dart';
import 'package:emp_recog_plat/core/ui/no_glow_scroll_behavior.dart';
import 'package:emp_recog_plat/core/util/constants.dart';
import 'package:emp_recog_plat/features/credentials/presentation/pages/sign_in.dart';
import 'package:emp_recog_plat/features/emp_dashboard/data/models/emp_model.dart';
import 'package:emp_recog_plat/features/emp_dashboard/domain/repositories/emp_profile_repository.dart';
import 'package:emp_recog_plat/features/emp_dashboard/presentation/bloc/emp_dashboard_bloc.dart';
import 'package:emp_recog_plat/features/emp_dashboard/presentation/widgets/categorical_cheer_item_widget.dart';
import 'package:emp_recog_plat/features/emp_dashboard/presentation/widgets/selected_profile_image_dialog.dart';
import 'package:emp_recog_plat/injection_container.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/ui/overlay_loader.dart' as OverlayLoader;

class EmployeeProfile extends StatefulWidget {
  final String id;

  const EmployeeProfile({Key key, this.id}) : super(key: key);

  @override
  _EmployeeProfileState createState() => _EmployeeProfileState();
}

class _EmployeeProfileState extends State<EmployeeProfile> {
  EmpDashboardBloc _bloc;
  bool _isSelf = true;

  EmployeeModel _employee;

  StreamSubscription _rankStreamSubscription;

  TextEditingController _aboutEditTextController = new TextEditingController();

  ImagePicker _imagePicker = ImagePicker();
  File _displayImage;

  bool _isVoted = false;
  bool _wasDisconnected = false;

  @override
  void initState() {
    super.initState();

    _isSelf = widget.id == null;

    _bloc = sl<EmpDashboardBloc>();
    _bloc.add(LoadProfileEvent(
        func: () =>
            sl<EmployeeProfileRepository>().getEmployeeProfile(id: widget.id)));
  }

  @override
  void dispose() {
    _rankStreamSubscription?.cancel();

    super.dispose();
  }

  void _openCamera() async {
    var image = await _imagePicker.getImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        maxHeight: 800);

    Navigator.pop(context);

    if (image != null) {
      _displayImage = File(image.path);

      bool isSave = await Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, _, __) => SelectedProfileImageDialog(
              selectedImage: _displayImage,
            ),
            opaque: false,
          ));

      if (isSave) {
        _bloc.add(UploadEmployeeImageEvent(
            func: () => sl<EmployeeProfileRepository>()
                .uploadEmployeeImage(imageFile: _displayImage)));
      }
    }
  }

  void _openGallery() async {
    var image = await _imagePicker.getImage(
        source: ImageSource.gallery,
        preferredCameraDevice: CameraDevice.rear,
        maxHeight: 800);

    Navigator.pop(context);

    if (image != null) {
      _displayImage = File(image.path);

      bool isSave = await Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, _, __) => SelectedProfileImageDialog(
              selectedImage: _displayImage,
            ),
            opaque: false,
          ));

      if (isSave) {
        _bloc.add(UploadEmployeeImageEvent(
            func: () => sl<EmployeeProfileRepository>()
                .uploadEmployeeImage(imageFile: _displayImage)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: _bloc,
      listener: (context, state) {
        if (state is LoggedOut) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => SignInBodyWidget(),
            ),
          );
        } else if (state is Saved) {
          if (state.type == "image")
            _employee.imageURL = state.data;
          else if (state.type == "about") _employee.about = state.data;
          _aboutEditTextController.text = state.data;
        }
      },
      child: BlocBuilder(
        cubit: _bloc,
        builder: (context, state) {
          if (state is LoadingProfile || state is Initial) {
            return Scaffold(body: LoadingWidget());
          } else if (state is LoadedProfile) {
            _employee = state.employee;

            if (_rankStreamSubscription == null) {
              getRankStream(_handleRankUpdate, context)
                  .then((sub) => _rankStreamSubscription = sub);
            }

            _aboutEditTextController.text = _employee.about ?? "";
          } else if (state is LoggingOut) {
            return Scaffold(
              body: OverlayLoader.Overlay(),
            );
          }

          return _buildBody(context);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return _isSelf
        ? Stack(
            children: [
              SafeArea(
                child: _buildInnerBody(context),
              ),
              BlocBuilder(
                cubit: _bloc,
                builder: (context, state) {
                  if (state is Saving) {
                    return OverlayLoader.Overlay();
                  }

                  return Container();
                },
              )
            ],
          )
        : WillPopScope(
            onWillPop: () {
              Navigator.pop(context, _isVoted);
              return Future.value(true);
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Stack(
                children: [
                  SafeArea(
                    child: _buildInnerBody(context),
                  ),
                  BlocBuilder(
                    cubit: _bloc,
                    builder: (context, state) {
                      if (state is Cheering) {
                        return OverlayLoader.Overlay();
                      }

                      return Container();
                    },
                  )
                ],
              ),
            ),
          );
  }

  Widget _buildInnerBody(BuildContext context) {
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
                func: () => sl<EmployeeProfileRepository>()
                    .getEmployeeProfile(id: widget.id)));
          }
        } else {
          _wasDisconnected = true;
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            titleSpacing: 10,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                mainAxisAlignment:
                    _isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  if (connected) ...[
                    _isSelf
                        ? Material(
                            borderRadius: BorderRadius.circular(5),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(5),
                              onTap: () {
                                _bloc.add(LogOutEmpEvent(
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
                          )
                        : GestureDetector(
                            onTap: () {
                              Navigator.pop(context, _isVoted);
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
                  ]
                ],
              ),
            ),
          ),
          body: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(
                        MediaQuery.of(context).size.width * 0.05),
                    bottomRight: Radius.circular(
                        MediaQuery.of(context).size.width * 0.05),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        _employee.name,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: MediaQuery.of(context).size.width * 0.3,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              border: _employee?.imageURL != null
                                  ? Border.all(width: 0)
                                  : Border.all(
                                      color: Colors.black.withOpacity(0.1),
                                      width: 2),
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.15),
                            ),
                            child: _employee?.imageURL != null
                                ? FadeInImage(
                                    image: CachedNetworkImageProvider(
                                      _employee.imageURL,
                                    ),
                                    placeholder: AssetImage("imgs/user.png"),
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset("imgs/user.png"),
                          ),
                          if (connected && _isSelf) ...[
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  _showAddReportImageBottomSheet();
                                },
                                child: CircleAvatar(
                                  backgroundColor:
                                      Color.fromRGBO(105, 157, 255, 1),
                                  radius:
                                      MediaQuery.of(context).size.width * 0.05,
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ]
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Text(
                        "Global",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black.withOpacity(0.6),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "Cheers",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Rank",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      indent: MediaQuery.of(context).size.width * 0.12,
                      endIndent: MediaQuery.of(context).size.width * 0.12,
                    ),
                    BlocBuilder(
                      cubit: _bloc,
                      builder: (context, state) {
                        if (state is Cheered) {
                          _employee.totalCheers =
                              state.updateMap['updatedTotalCount'];
                        } else if (state is RankUpdated) {
                          _employee.rank = state.rank;
                        }

                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.15 +
                                      10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  _employee.totalCheers,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  _employee.rank,
                                  textAlign: TextAlign.end,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ScrollConfiguration(
                    behavior: NoGlowScrollBehavior(),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Center(
                            child: Column(
                              children: [
                                if (_isSelf) ...[
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      _employee.id,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ],
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    _employee.designation,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "About",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black.withOpacity(0.6),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (connected && _isSelf) ...[
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(100),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(100),
                                      onTap: () async {
                                        await showDialog<String>(
                                          context: context,
                                          child: new AlertDialog(
                                            title: Center(
                                              child: Text("About"),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.all(16.0),
                                            content: new Row(
                                              children: <Widget>[
                                                new Expanded(
                                                  child: new TextField(
                                                    controller:
                                                        _aboutEditTextController,
                                                    autofocus: true,
                                                    decoration: new InputDecoration(
                                                        labelText: 'About',
                                                        hintText:
                                                            'eg. I am a hardworking person...'),
                                                  ),
                                                )
                                              ],
                                            ),
                                            actions: <Widget>[
                                              new FlatButton(
                                                  child: const Text('CANCEL'),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  }),
                                              new FlatButton(
                                                  child: const Text('Save'),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    _bloc.add(UpdateEmployeeAboutEvent(
                                                        func: () => sl<
                                                                EmployeeProfileRepository>()
                                                            .updateEmployeeAbout(
                                                                aboutTxt:
                                                                    _aboutEditTextController
                                                                        .text)));
                                                  })
                                            ],
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(5),
                                        child: Icon(
                                          Icons.edit,
                                          color: Theme.of(context).primaryColor,
                                          size: 22,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ]
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            _employee.about ?? "None",
                            textAlign: TextAlign.justify,
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.8)),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Badges",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black.withOpacity(0.6),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          _employee.badges.isNotEmpty
                              ? Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 40,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: _employee.badges != null
                                              ? _employee.badges.length
                                              : 0,
                                          itemBuilder: (context, index) =>
                                              Container(
                                            width: 40,
                                            height: 40,
                                            margin: const EdgeInsets.only(
                                                right: 10),
                                            child: FadeInImage(
                                              image: NetworkImage(
                                                  _employee.badges[index]),
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
                              : Text(
                                  "None",
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                ),
                          SizedBox(
                            height: 30,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Categorical Cheers",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black.withOpacity(0.6),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          BlocBuilder(
                            cubit: _bloc,
                            builder: (context, state) {
                              if (state is Cheered) {
                                _employee.traitCheers[
                                        state.updateMap['traitID']] =
                                    state.updateMap['updatedCount'];
                                _employee.alreadyVoted[
                                    state.updateMap['traitID']] = "Trait ID";
                              }

                              return ListView(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: Constant.TRAIT_LABELS.keys
                                    .toList()
                                    .map(
                                      (trait) => CategoricalCheerItemWidget(
                                        isSelf: _isSelf,
                                        trait: trait,
                                        traitCount:
                                            _employee.traitCheers[trait] ?? "0",
                                        isDisabled: _employee?.alreadyVoted
                                            ?.containsKey(trait),
                                        func: () {
                                          if (!_employee?.alreadyVoted
                                              ?.containsKey(trait)) {
                                            _isVoted = true;
                                            _bloc.add(
                                              CheerForEmpEvent(
                                                func: () =>
                                                    sl<EmployeeProfileRepository>()
                                                        .cheerForEmployee(
                                                            empID: widget.id,
                                                            traitID: trait),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    )
                                    .toList(),
                              );
                            },
                          ),
                          SizedBox(
                            height: 30,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      child: Container(),
    );
  }

  _showAddReportImageBottomSheet() {
    return showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                color: Colors.black.withOpacity(0.2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _bottomSheetRowItem(
                      icon: Icons.camera_alt,
                      label: "Camera",
                      onTap: () => _openCamera(),
                    ),
                    _bottomSheetRowItem(
                      icon: Icons.image,
                      label: "Gallery",
                      onTap: () => _openGallery(),
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }

  Widget _bottomSheetRowItem(
      {IconData icon, String label, bool isBorder = true, Function onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30),
          decoration: BoxDecoration(
            border: Border(
              bottom: isBorder
                  ? BorderSide(color: Color(0xFF1B5E79), width: 0.1)
                  : BorderSide.none,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Color(0xFF1B5E79),
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                label,
                style: TextStyle(
                    fontSize: 15, color: Colors.black.withOpacity(0.7)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<StreamSubscription<Event>> getRankStream(
      void onData(context, String rank), context) async {
    return FirebaseInit.dbRef
        .child(
            "monthly_temp/ranking/global/${widget.id ?? FirebaseInit.auth.currentUser.uid}")
        .onValue
        .listen((event) {
      onData(
          context,
          event.snapshot.value != null
              ? (event.snapshot.value + 1).toString()
              : "N/A");
    });
  }

  _handleRankUpdate(context, String rank) {
    sl<EmployeeProfileRepository>().cacheRank(rank);
    _bloc.add(UpdateRankEvent(rank: rank));
  }
}
