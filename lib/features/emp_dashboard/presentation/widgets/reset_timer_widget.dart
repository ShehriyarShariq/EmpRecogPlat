import 'package:flutter/material.dart';

class ResetTimerWidget extends StatefulWidget {
  @override
  _ResetTimerWidgetState createState() => _ResetTimerWidgetState();
}

class _ResetTimerWidgetState extends State<ResetTimerWidget> {
  String _timer = '00:00:00';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Center(
          child: Text(
        "Resets in $_timer",
        style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.6)),
      )),
    );
  }
}
