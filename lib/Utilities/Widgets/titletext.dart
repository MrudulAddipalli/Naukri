import 'package:flutter/material.dart';

import '../../Constansts/theme.dart' as Theme;

class TitleText extends StatelessWidget {
  final String text;
  TitleText({
    Key key,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
        child: Text(
          text,
          textAlign: TextAlign.start,
          style: Theme.blue_textstyle,
        ),
      ),
    );
  }
}
