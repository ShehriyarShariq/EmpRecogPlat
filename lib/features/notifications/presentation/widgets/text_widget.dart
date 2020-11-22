import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String txt;
  const TextWidget({Key key, this.txt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black.withOpacity(0.1)),
        ),
      ),
      child: Text(
        txt,
        style: TextStyle(
          color: Color(0xFF283E4A),
          fontSize: 15,
        ),
      ),
    );
  }
}
