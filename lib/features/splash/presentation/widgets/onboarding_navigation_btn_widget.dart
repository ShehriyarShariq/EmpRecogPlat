import 'package:flutter/material.dart';

class OnboardingNavBtnWidget extends StatelessWidget {
  final Function fun;

  const OnboardingNavBtnWidget({Key key, this.fun}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onPressed: fun,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.268,
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Row(
            children: [
              Text(
                'Continue',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.7),
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w400,
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.black.withOpacity(0.7),
                size: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
