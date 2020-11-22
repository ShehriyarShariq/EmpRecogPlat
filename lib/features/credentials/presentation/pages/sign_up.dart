import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../core/ui/no_glow_scroll_behavior.dart';
import '../../../../core/ui/overlay_loader.dart' as OverlayLoader;
import '../../../../core/util/constants.dart';
import '../../../../injection_container.dart';
import '../../data/models/credentials_model.dart';
import '../../domain/repositories/credentials_repository.dart';
import '../bloc/bloc/credentials_bloc.dart';
import '../widgets/input_widget.dart';

class SignUpBodyWidget extends StatefulWidget {
  @override
  _SignUpBodyWidgetState createState() => _SignUpBodyWidgetState();
}

class _SignUpBodyWidgetState extends State<SignUpBodyWidget> {
  TextEditingController empIDInput = TextEditingController(),
      emailInput = TextEditingController(),
      passInput = TextEditingController();

  bool _isEmployee = true;

  CredentialsBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = sl<CredentialsBloc>();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return BlocListener(
      cubit: _bloc,
      listener: (context, state) {
        if (state is Registered) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.75,
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.06,
                            bottom: 20),
                        child: Align(
                          alignment: Alignment.center,
                          child: Image.asset("imgs/cheerio_logo.png"),
                        ),
                      ),
                      Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                        Text(
                          'Register a new account',
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: Constant.DEFAULT_FONT,
                              fontWeight: FontWeight.w500),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width * 0.05,
                              left: 15,
                              right: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              _buildTabToggler(),
                              SizedBox(
                                height: 15,
                              ),
                              InputWidget(
                                hintText: "Employee #",
                                controller: empIDInput,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              InputWidget(
                                hintText: "Email",
                                type: "email",
                                controller: emailInput,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              InputWidget(
                                hintText: "Password",
                                type: "password",
                                isPass: true,
                                controller: passInput,
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: RaisedButton(
                                    elevation: 0.5,
                                    color: Theme.of(context).primaryColor,
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 60,
                                      child: Text(
                                        'CREATE ACCOUNT',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontFamily: Constant.DEFAULT_FONT),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (empIDInput.text.trim().isNotEmpty &&
                                          emailInput.text.trim().isNotEmpty &&
                                          passInput.text.trim().isNotEmpty) {
                                        _bloc.add(RegisterUserEvent(
                                            func: () =>
                                                sl<CredentialsRepository>()
                                                    .signUpWithCredentials(
                                                        CredentialsModel(
                                                  empID: empIDInput.text.trim(),
                                                  email: emailInput.text.trim(),
                                                  password:
                                                      passInput.text.trim(),
                                                ))));
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "Invalid Input",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.grey[700],
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      }
                                      // if (_isEnabled) {
                                      //   UserCredSingleton userCredSingleton =
                                      //       UserCredSingleton();
                                      //   userCredSingleton.userCred.reset();

                                      //   widget.bloc.add(SaveFetchedValueEvent(
                                      //       type: "isSignIn", property: false));
                                      //   widget.bloc.add(FetchAllDataEvent());
                                      // }
                                    }),
                              ),
                              SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Already have an account? ',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: Constant.DEFAULT_FONT),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: Text(
                                      'Sign In',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontFamily: Constant.DEFAULT_FONT,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
            BlocBuilder(
              cubit: _bloc,
              builder: (context, state) {
                if (state is Processing) {
                  return OverlayLoader.Overlay();
                }

                return Container();
              },
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
                    if (!_isEmployee) {
                      setState(() {
                        _isEmployee = true;
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: _isEmployee
                            ? Theme.of(context).primaryColor.withOpacity(0.1)
                            : Colors.transparent,
                        border: Border.all(
                            color: _isEmployee
                                ? Theme.of(context).primaryColor
                                : Colors.black.withOpacity(0.4)),
                        borderRadius: BorderRadius.circular(3)),
                    child: Center(
                      child: Text(
                        "Employee",
                        style: TextStyle(
                            fontSize: 17,
                            fontFamily: Constant.DEFAULT_FONT,
                            color: _isEmployee
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
                    Fluttertoast.showToast(
                        msg: "Admin Signup disabled",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey[700],
                        textColor: Colors.white,
                        fontSize: 16.0);
                    // if (_isEmployee) {
                    //   setState(() {
                    //     _isEmployee = false;
                    //   });
                    // }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: !_isEmployee
                            ? Theme.of(context).primaryColor.withOpacity(0.1)
                            : Colors.transparent,
                        border: Border.all(
                            color: !_isEmployee
                                ? Theme.of(context).primaryColor
                                : Colors.black.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(3)),
                    child: Center(
                      child: Text(
                        "Admin",
                        style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontSize: 17,
                            fontFamily: Constant.DEFAULT_FONT,
                            color: !_isEmployee
                                ? Theme.of(context).primaryColor
                                : Colors.black.withOpacity(0.2)),
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
}
