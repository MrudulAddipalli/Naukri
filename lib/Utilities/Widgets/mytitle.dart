import 'package:flutter/material.dart';

import '../../Constansts/theme.dart' as Theme;

class MyTitle extends StatelessWidget {
  final String text;
  MyTitle({this.text});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: Theme.title_textfield_textstyle_25,
    );
  }
}
