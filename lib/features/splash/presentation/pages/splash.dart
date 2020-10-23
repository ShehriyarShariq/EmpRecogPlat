import 'package:emp_recog_plat/features/admin_dashboard/presentation/pages/admin_dashboard.dart';
import 'package:emp_recog_plat/features/emp_dashboard/presentation/pages/emp_dashboard.dart';
import 'package:emp_recog_plat/features/splash/domain/repositories/splash_repository.dart';
import 'package:emp_recog_plat/features/splash/presentation/bloc/bloc/splash_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../../credentials/presentation/pages/sign_in.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  SplashBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = sl<SplashBloc>();
    _bloc.add(CheckCurrentUserEvent(
        func: () => sl<SplashRepository>().checkCurrentUser()));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).primaryColor,
          statusBarBrightness: Brightness.light),
    );

    Future.delayed(Duration(seconds: 2), () {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      );
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => SignInBodyWidget()));
    });

    return BlocListener(
      cubit: _bloc,
      listener: (context, state) {
        if (state is Success) {
          if (state.map['isSignedIn']) {
            if (state.map['isEmp']) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => EmployeeDashboard()));
            } else {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => AdminDashboard()));
            }
          } else {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => SignInBodyWidget()));
          }
        }
      },
      child: Container(
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
