import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../core/ui/no_glow_scroll_behavior.dart';
import '../../../../core/ui/overlay_loader.dart' as OverlayLoader;
import '../../../../core/util/constants.dart';
import '../../../../injection_container.dart';
import '../../../admin_dashboard/presentation/pages/admin_dashboard.dart';
import '../../../emp_dashboard/presentation/pages/emp_dashboard.dart';
import '../../data/models/credentials_model.dart';
import '../../domain/repositories/credentials_repository.dart';
import '../bloc/bloc/credentials_bloc.dart';
import '../widgets/input_widget.dart';
import 'sign_up.dart';

class SignInBodyWidget extends StatefulWidget {
  final CredentialsBloc bloc;
  final bool showSignIn;

  SignInBodyWidget({Key key, this.showSignIn, this.bloc}) : super(key: key);

  @override
  _SignInBodyWidgetState createState() => _SignInBodyWidgetState();
}

class _SignInBodyWidgetState extends State<SignInBodyWidget> {
  TextEditingController emailInput = TextEditingController(),
      passInput = TextEditingController();
  bool _isEnabled = true;

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
        if (state is Success) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (_) =>
                  state.isAdmin ? AdminDashboard() : EmployeeDashboard()));
        } else if (state is Error) {
          Fluttertoast.showToast(
              msg: state.errorMessage,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey[700],
              textColor: Colors.white,
              fontSize: 16.0);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.12,
                          bottom: 50),
                      child: Text(
                        "TMB",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 48),
                      ),
                    ),
                    Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(
                            'Sign In to continue',
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.w500),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.width * 0.05,
                                left: 15,
                                right: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
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
                                // SizedBox(height: 10),
                                // Align(
                                //   alignment: Alignment.centerRight,
                                //   child: GestureDetector(
                                //     onTap: () {
                                //       // Open ForgotPassword page

                                //       // Navigator.of(context).push(MaterialPageRoute(
                                //       //     builder: (_) => ForgotPasswordWidget()));
                                //     },
                                //     child: Text(
                                //       'Forgot Password?',
                                //       style: TextStyle(
                                //           fontSize: 17,
                                //           fontFamily: Constant.DEFAULT_FONT,
                                //           color: Theme.of(context).primaryColor),
                                //     ),
                                //   ),
                                // ),
                                SizedBox(height: 30),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: RaisedButton(
                                      elevation: 0.5,
                                      color: Theme.of(context).primaryColor,
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 60,
                                        child: Text(
                                          'SIGN IN',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontFamily:
                                                  Constant.DEFAULT_FONT),
                                        ),
                                      ),
                                      onPressed: () {
                                        if (emailInput.text.trim().isNotEmpty &&
                                            passInput.text.trim().isNotEmpty) {
                                          _bloc.add(LoginWithCredentialsEvent(
                                              func: () =>
                                                  sl<CredentialsRepository>()
                                                      .signInWithCredentials(
                                                          CredentialsModel(
                                                    email:
                                                        emailInput.text.trim(),
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
                                      }),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.063),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Don\'t have an account? ',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: Constant.DEFAULT_FONT,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    SignUpBodyWidget()));
                                      },
                                      child: Text(
                                        'Create account',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontFamily: Constant.DEFAULT_FONT,
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
}
