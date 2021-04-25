import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/AuthProvider.dart';
import '../Models/User.dart';
import '../Utilities/Widgets/appbar.dart';
import "../Utilities/UIHelpers/dailogs.dart";
import '../Utilities/Widgets/largebutton.dart';
import '../Utilities/Widgets/Recruiter/recruiteralljobs.dart';
import '../Utilities/Widgets/Recruiter/apliedcandidatejob.dart';

import "../Utilities/UIHelpers/modalhelper.dart";
import "../Utilities/Widgets/Recruiter/addeditjobform.dart";
import "../Constansts/theme.dart" as Theme;

class RecruiterScreen extends StatefulWidget {
  @override
  _RecruiterScreenState createState() => _RecruiterScreenState();
}

class _RecruiterScreenState extends State<RecruiterScreen> {
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
      appBar: myAppBar(
        username: "${user.name}",
        callback: () async {
          bool status = await confirmLogout();
          if (status) {
            authProvider.logout();
            // Navigator.popAndPushNamed(context, "/SignIn");
            Navigator.popAndPushNamed(context, "/");
          }
        },
      ),
      backgroundColor: Colors.white,
      body: (_currentIndex == 0) ? RecruiterAllJobs() : AppliedCandidateJobs(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.grey_bg_1,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.work),
            label: 'Posted Jobs',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.account_circle_rounded),
            label: 'Applied Candidates',
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
      floatingActionButton: FloatingActionButton.extended(
        elevation: 5,
        onPressed: () {
          ModalHelper.getInstance.show(context, AddEditJobForm());
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(35))),
        icon: Icon(Icons.add),
        label: Text("Post New Job", style: Theme.white_textstyle),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
