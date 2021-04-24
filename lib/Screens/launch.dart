import 'package:flutter/material.dart';
import "dart:async";
import 'package:provider/provider.dart';

import '../Models/User.dart';

import '../Providers/AuthProvider.dart';
import '../Screens/singin.dart';
import '../Screens/splash.dart';
import '../Screens/dashboard.dart';
import '../Screens/candidatescreen.dart';

class Launch extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Launch> {
  bool loading = true;
  bool autoSignInSuccessfull = false;
  var authProvider;
  // User loggedInUser;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      autoSignInCheck();
    });
  }

  void autoSignInCheck() async {
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    bool autoSignInStatus = await authProvider.autoSignIn();
    // loggedInUser = authProvider.loggedInUser;
    setState(() {
      autoSignInSuccessfull = autoSignInStatus;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (loading)
        ? Splash()
        : (autoSignInSuccessfull)
            ? DashBoard()
            // ? (loggedInUser.userRole == 0)
            //     ? CandidateScreen() // Candidate Page
            //     : CandidateScreen() // Recruiter Page
            : SignIn();
  }
}
