import 'package:flutter/material.dart';

import '../../Constansts/theme.dart' as Theme;

class Dialogs {
  static Dialogs _instance;
  Dialogs._();
  static Dialogs get getInstance => _instance ??= Dialogs._();

  Future confirmDialog(
      {BuildContext context,
      String title,
      String subtitle,
      Widget actions}) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext cx) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          content: Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment(0.0, 0.5),
                  colors: <Color>[
                    Color(0xff0593d6),
                    Color(0xff0692d6),
                    Color(0xff1c6bb5),
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null)
                    Text(
                      title ?? "",
                      textAlign: TextAlign.center,
                      style: Theme.title_textfield_textstyle_25_white,
                    ),
                  if (subtitle != null) SizedBox(height: 20),
                  if (subtitle != null)
                    Text(
                      subtitle ?? "",
                      textAlign: TextAlign.center,
                      style: Theme.white_textstyle,
                    ),
                  SizedBox(height: 20),
                  SizedBox(height: 50, child: actions), // buttons
                ],
              )),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          // actions: <Widget>[],
        );
      },
    );
  }
}
