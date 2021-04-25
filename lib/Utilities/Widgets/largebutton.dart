import 'package:flutter/material.dart';

import '../../Constansts/theme.dart' as Theme;

class LargeButton extends StatelessWidget {
  final void Function() callback;
  final String text;
  final String type;
  LargeButton({this.text, this.callback, this.type});

  Map<String, List<Color>> color = {
    "blue": [
      Color(0xff2B7BF7),
      Color(0xff0692d6),
      Color(0xff1C63E6),
    ],
    "green": [
      Color(0xff02c290),
      Color(0xff11b288),
      Color(0xff1da481),
    ],
    "grey": [Theme.grey_bg, Theme.grey_bg]
  };
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        width: (MediaQuery.of(context).size.width < 450)
            ? MediaQuery.of(context).size.width * 0.9
            : 400,
        height: 60,
        // margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment(0.0, 0.5),
            colors: color["$type"],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            text ?? "",
            style: TextStyle(
                fontSize: 20,
                color: (type == "grey") ? Colors.black : Colors.white,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
