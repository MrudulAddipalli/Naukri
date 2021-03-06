import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/AuthProvider.dart';
import '../Models/User.dart';
import '../Utilities/Widgets/appbar.dart';
import "../Utilities/UIHelpers/dailogs.dart";
import '../Utilities/Widgets/largebutton.dart';
import '../Utilities/Widgets/Candidates/candidatealljobs.dart';
import '../Utilities/Widgets/Candidates/candidateappliedjobs.dart';

import "../Constansts/theme.dart" as Theme;

class CandidateScreen extends StatefulWidget {
  @override
  _CandidateScreenState createState() => _CandidateScreenState();
}

class _CandidateScreenState extends State<CandidateScreen> {
  int _currentIndex = 0;
  var authProvider;
  User user;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    user = authProvider.loggedInUser;
  }

  Future<bool> confirmLogout() async {
    return await Dialogs.getInstance.confirmDialog(
      context: context,
      title: "Are you sure?",
      subtitle: "you want to logout?",
      actions: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 5,
            child: LargeButton(
              text: "No",
              callback: () {
                Navigator.of(context).pop(false);
              },
              type: "green",
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(""),
          ),
          Expanded(
            flex: 5,
            child: LargeButton(
              text: "Yes",
              callback: () {
                Navigator.of(context).pop(true);
              },
              type: "green",
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 5,
      //   title: Text("Hi, ${user.name}"),
      //   actions: [
      //     InkWell(
      //       onTap: () async {
      // bool status = await confirmLogout();
      // if (status) {
      //   authProvider.logout();
      //   Navigator.popAndPushNamed(context, "/SignIn");
      // }
      //       },
      //       child: Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: Icon(Icons.logout, size: 25),
      //       ),
      //     )
      //   ],
      // ),
      appBar: myAppBar(
        username: "${user.name}",
        callback: () async {
          bool status = await confirmLogout();
          if (status) {
            authProvider.logout();
            Navigator.popAndPushNamed(context, "/SignIn");
            // Navigator.popAndPushNamed(context, "/SignIn");
            Navigator.popAndPushNamed(context, "/");
          }
        },
      ),
      backgroundColor: Colors.white,
      body: (_currentIndex == 0) ? CandidateAllJobs() : CandidateAppliedJobs(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.grey_bg_1,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.work),
            label: 'All Jobs',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.mail),
            label: 'Applied Jobs',
          ),
        ],
        onTap: (index) {
          if (_currentIndex != index) {
            setState(() {
              _currentIndex = index;
            });
          }
        },
      ),
    );
  }
}
