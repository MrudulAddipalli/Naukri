import 'package:flutter/material.dart';

class MainLogo extends StatelessWidget {
  final String imagepath;
  final double height;
  final double width;
  const MainLogo({this.imagepath, this.height, this.width});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: (height == null) ? 120 : height,
      width: (width == null) ? 120 : width,
      child: (imagepath == null || imagepath == "")
          ? Image(image: AssetImage('assets/images/main_logo.png'))
          : Image(image: AssetImage(imagepath)),
    );
  }
}
