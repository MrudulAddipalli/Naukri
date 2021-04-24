import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/AuthProvider.dart';
import '../Providers/JobProvider.dart';
import '../Models/User.dart';
import '../Models/Job.dart';

import "../Utilities/UIHelpers/dailogs.dart";
import '../Utilities/Widgets/largebutton.dart';
import '../Utilities/Widgets/candidatejoblist.dart';
import '../../Constansts/theme.dart' as Theme;

class CandidateScreen extends StatefulWidget {
  @override
  _CandidateScreenState createState() => _CandidateScreenState();
}

class _CandidateScreenState extends State<CandidateScreen> {
  int _currentIndex = 0;
  var authProvider;
  var jobProvider;
  User user;
  Map<String, dynamic> errors;
  Job jobData;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    jobProvider = Provider.of<JobProvider>(context, listen: false);
    user = authProvider.loggedInUser;
    () async {
      await getAllJobs();
    }();
  }

  getAllJobs() async {
    Map<String, dynamic> response = await jobProvider.getAllJobs();

    if (response["status"] == "success") {
      print("success - show job data");
      setState(() {
        errors = null;
        jobData = response["jobData"];
      });
    } else {
      print("failed");
      setState(() {
        errors = response["errors"];
      });

      if (errors["generalerror"].toString() != "null") {
        bool status = await Dialogs.getInstance.confirmDialog(
          context: context,
          title: "Alert",
          subtitle: errors["generalerror"],
          actions: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 5,
                child: LargeButton(
                  text: "Cancel",
                  callback: () {
                    Navigator.of(context).pop(false);
                  },
                  type: "green",
                ),
              ),
            ],
          ),
        );
        print("status $status");
      }
    }
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
      appBar: AppBar(
        elevation: 5,
        title: Text("Hi, ${user.name}"),
        actions: [
          InkWell(
            onTap: () async {
              bool status = await confirmLogout();
              if (status) {
                authProvider.logout();
                Navigator.popAndPushNamed(context, "/SignIn");
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.logout, size: 25),
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: (jobData != null)
            ? (_currentIndex == 0)
                ? CandidateJobList(jobs: jobData)
                : CandidateJobList(jobs: jobData)
            : Center(
                child: (errors == null)
                    ? CircularProgressIndicator()
                    : Text('Oops!! Something Went Wrong'),
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 20,
        backgroundColor: Colors.white,
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
