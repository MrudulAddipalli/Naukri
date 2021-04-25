import 'package:flutter/material.dart';

AppBar myAppBar({Function callback, String username}) {
  return AppBar(
    elevation: 5,
    title: Text("Hi, $username"),
    actions: [
      InkWell(
        onTap: () async {
          await callback();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.logout, size: 25),
        ),
      )
    ],
  );
}
