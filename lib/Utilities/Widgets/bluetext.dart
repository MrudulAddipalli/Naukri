import 'package:flutter/material.dart';

import '../../Constansts/theme.dart' as Theme;

class BlueText extends StatelessWidget {
  final String text;
  BlueText({this.text});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: Theme.blue_textstyle,
    );
  }
}
