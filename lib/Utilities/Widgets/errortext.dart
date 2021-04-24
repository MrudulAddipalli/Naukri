import 'package:flutter/material.dart';

import '../../Constansts/theme.dart' as Theme;

class ErrorText extends StatelessWidget {
  final String text;
  ErrorText({this.text});
  @override
  Widget build(BuildContext context) {
    return (text != null && text != "" && text != "null")
        ? Container(
            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    textAlign: TextAlign.start,
                    style: Theme.error_textstyle,
                  ),
                ),
              ],
            ),
          )
        : Container();
  }
}
