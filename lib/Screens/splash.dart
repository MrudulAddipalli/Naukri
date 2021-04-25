import 'package:flutter/material.dart';
import '../../Utilities/Widgets/mainlogo.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
                child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MainLogo(),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
