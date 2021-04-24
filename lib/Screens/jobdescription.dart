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

class JobDescription extends StatefulWidget {
  String jobId;
  JobDescription({this.jobId});
  @override
  _JobDescriptionState createState() => _JobDescriptionState();
}

class _JobDescriptionState extends State<JobDescription> {
  //
  var authProvider;
  var jobProvider;
  Map<String, dynamic> errors;
  Data singleJobDesc; // Job->Data
  User user;

  //
  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    jobProvider = Provider.of<JobProvider>(context, listen: false);
    user = authProvider.loggedInUser;
    () async {
      await getJobDescription();
    }();
  }

  getJobDescription() async {
    Map<String, dynamic> response =
        await jobProvider.jobDescriptionFor(widget.jobId);

    if (response["status"] == "success") {
      print("success - show job data");
      setState(() {
        errors = null;
        singleJobDesc = response["singleJobDesc"];
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: (singleJobDesc != null)
          ? Container(
              child: Text("effs"),
            )
          : Center(
              child: (errors == null)
                  ? CircularProgressIndicator()
                  : Text('Oops!! Something Went Wrong'),
            ),
    );
  }
}
