import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/AuthProvider.dart';

import '../Models/User.dart';
import '../Screens/candidatescreen.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  var authProvider;
  User loggedInUser;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    loggedInUser = authProvider.loggedInUser;
  }

  @override
  Widget build(BuildContext context) {
    return (loggedInUser.userRole == 0) ? CandidateScreen() : CandidateScreen();
  }
}
