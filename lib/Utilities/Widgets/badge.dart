import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final text;
  final Color color;
  Badge(this.text, [this.color = Colors.blue]);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(7),
      child: Material(
        // elevation: 6,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color,
            boxShadow: [
              BoxShadow(
                  blurRadius: 8,
                  offset: Offset(0, 15),
                  color: color.withOpacity(.6),
                  spreadRadius: -9)
            ],
          ),
          child:
              Text(text, style: TextStyle(color: Colors.white, fontSize: 15)),
        ),
      ),
    );
  }
}
