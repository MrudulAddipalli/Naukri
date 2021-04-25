import 'package:flutter/material.dart';

class MyTextButton extends StatelessWidget {
  String text;
  Function() callback;
  Color color;
  MyTextButton({
    this.text,
    this.callback,
    this.color,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: InkWell(
        onTap: callback,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Text(
            text ?? "",
            style: TextStyle(
              fontSize: 16,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
