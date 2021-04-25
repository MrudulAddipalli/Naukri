import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Providers/JobProvider.dart';
import '../../../Models/Job.dart';
import "../../../Utilities/UIHelpers/dailogs.dart";
import '../../Widgets/largebutton.dart';
import '../../Widgets/Recruiter/recruiterjoblist.dart';
import "../../../Constansts/theme.dart" as Theme;

class AppliedCandidateJobs extends StatefulWidget {
  @override
  AppliedCandidateJobsState createState() => AppliedCandidateJobsState();
}

class AppliedCandidateJobsState extends State<AppliedCandidateJobs> {
  var jobProvider;
  Map<String, dynamic> errors;
  List<Data> jobData; // Job -> Data

  @override
  void initState() {
    super.initState();
    jobProvider = Provider.of<JobProvider>(context, listen: false);
    () async {
      await getJobDetails();
    }();
  }

  getJobDetails() async {
    Map<String, dynamic> response =
        await jobProvider.getAllRecruiterPostedJobs();
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

  @override
  Widget build(BuildContext context) {
    return (jobData == null)
        ? Center(
            child: (errors == null)
                ? CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.popAndPushNamed(context, "/");
                          },
                          child:
                              Icon(Icons.refresh, size: 40, color: Theme.blue)),
                      SizedBox(height: 10),
                      Text('Oops!! Something Went Wrong'),
                    ],
                  ),
          )
        : RefreshIndicator(
            onRefresh: () async {
              setState(() {
                jobData = null;
                errors = null;
                getJobDetails();
              });
            },
            child: RecruiterJobList(
              jobData: jobData,
              type: "appliedjobs",
            ),
          );
  }
}
