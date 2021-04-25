import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Providers/AuthProvider.dart';
import '../../../Providers/JobProvider.dart';
import '../../../Models/User.dart';
import '../../../Models/Job.dart';
import '../../../Utilities/UIHelpers/datetimehelper.dart';
import '../../../Utilities/Widgets/mainlogo.dart';
import "../../../Utilities/UIHelpers/dailogs.dart";
import '../../../Utilities/Widgets/largebutton.dart';
import '../../../Utilities/Widgets/mytextbutton.dart';
import '../../../../Constansts/theme.dart' as Theme;

import "../../UIHelpers/modalhelper.dart";
import "../../Widgets/Recruiter/addeditjobform.dart";

class RecruiterJobDescription extends StatefulWidget {
  String jobId;
  String type;
  RecruiterJobDescription({this.jobId, this.type});
  @override
  _RecruiterJobDescriptionState createState() =>
      _RecruiterJobDescriptionState();
}

class _RecruiterJobDescriptionState extends State<RecruiterJobDescription> {
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
    print("Show Job Description For - ${widget.jobId}");
    return Center(
      child: (singleJobDesc != null)
          ? Description(singleJobDesc: singleJobDesc, type: widget.type)
          : Center(
              child: (errors == null)
                  ? CircularProgressIndicator()
                  : Text('Oops!! Something Went Wrong'),
            ),
    );
  }
}

class Description extends StatefulWidget {
  final Data singleJobDesc;
  final String type;
  Description({
    Key key,
    this.singleJobDesc,
    this.type,
  }) : super(key: key);

  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  //
  Map<String, dynamic> errors = {};
  var jobProvider;
  var authProvider;
  bool applied = false;
  //
  //
  @override
  void initState() {
    super.initState();
    jobProvider = Provider.of<JobProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  Future _deleteDialog(BuildContext cx, String jobID) async {
    showDialog(
      context: cx,
      barrierDismissible: false,
      builder: (BuildContext cx) {
        return AlertDialog(
          title: Text("Are you Sure ?"),
          content: Text("you want to delete this category?"),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          actions: <Widget>[
            MyTextButton(
              text: "No",
              color: Colors.blueAccent,
              callback: () {
                Navigator.pop(context);
              },
            ),
            MyTextButton(
              text: "Yes",
              color: Colors.redAccent,
              callback: () async {
                Map<String, dynamic> response =
                    await jobProvider.deleteJob(jobID);
                //
                if (response["status"] == "success") {
                  print("success");
                  setState(() {
                    errors = {};
                  });
                  //
                  Navigator.pop(cx); // delete alert popup
                  Navigator.pop(context); //Job Description
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Job Deleted Successfully'),
                    duration: Duration(seconds: 3),
                  ));
                  Navigator.popAndPushNamed(context, "/DashBoard");
                  //
                } else {
                  print("failed");
                  setState(() {
                    errors = response["errors"];
                  });

                  //
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
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left,
            size: 25,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            color: Colors.white,
            iconSize: 25,
            onPressed: () {
              print("delete job");
              _deleteDialog(context, widget.singleJobDesc.id);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            // width: MediaQuery.of(context).size.width * 0.9,
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.singleJobDesc.title ?? "Job Title",
                            textAlign: TextAlign.start,
                            style: Theme.title_textfield_textstyle_25,
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.place,
                                color: Colors.grey,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text(
                                  widget.singleJobDesc.location ??
                                      "Job Location",
                                  softWrap: true,
                                  maxLines: 2,
                                  style: Theme.black_textstyle,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: MainLogo(),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Divider(thickness: 2),
                SizedBox(height: 10),
                Text(
                  "Job Details",
                  style: Theme.bold_black_textstyle,
                ),
                SizedBox(height: 10),
                Text(
                  widget.singleJobDesc.description ?? "Job Details",
                  style: Theme.black_textstyle,
                ),
                SizedBox(height: 10),
                Divider(thickness: 2),
                SizedBox(height: 10),
                Text(
                  "last Updated On - ${timeAgo(widget.singleJobDesc.updatedAt)}" ??
                      "Time",
                  style: Theme.black_textstyle,
                ),
                SizedBox(height: 30),
                Text(
                  "Job Id \n\n${widget.singleJobDesc.id * 5}" ?? "Time",
                  style: Theme.black_textstyle,
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   elevation: 5,
      //   onPressed: () async {
      //     print("edit");
      //     Navigator.pop(context);
      //     ModalHelper.getInstance
      //         .show(context, AddEditJobForm(jobData: widget.singleJobDesc));
      //   },
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.all(
      //       Radius.circular(35),
      //     ),
      //   ),
      //   icon: Icon(Icons.edit),
      //   label: Text(
      //     "  Edit  ",
      //     style: Theme.white_textstyle,
      //   ),
      // ),
      // // for Applied Job
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
