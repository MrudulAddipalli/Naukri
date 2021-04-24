import 'package:flutter/material.dart';

import '../../Constansts/theme.dart' as Theme;

class MyContainer extends StatelessWidget {
  final Widget child;
  MyContainer({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 2, color: Theme.grey_border),
        color: Theme.grey_bg_1,
      ),
      child: Center(child: child),
    );
  }
}
