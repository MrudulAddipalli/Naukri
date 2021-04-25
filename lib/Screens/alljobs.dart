import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Providers/JobProvider.dart';
import '../../../Models/Job.dart';
import "../../../Utilities/UIHelpers/dailogs.dart";
import '../Utilities/Widgets/largebutton.dart';
import './alljoblist.dart';

class AllJobs extends StatefulWidget {
  @override
  AllJobsState createState() => AllJobsState();
}

class AllJobsState extends State<AllJobs> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: Text("Naukri.com"),
      ),
      backgroundColor: Colors.white,
      body: (jobData == null)
          ? Center(
              child: (errors == null)
                  ? CircularProgressIndicator()
                  : Text('Oops!! Something Went Wrong'),
            )
          : RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  jobData = null;
                  errors = null;
                  getJobDetails();
                });
              },
              child: AllJobList(jobData: jobData),
            ),
    );
  }
}
