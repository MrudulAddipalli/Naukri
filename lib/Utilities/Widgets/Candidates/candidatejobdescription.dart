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
import '../../../../Constansts/theme.dart' as Theme;

class CandidateJobDescription extends StatefulWidget {
  String jobId;
  String type;
  CandidateJobDescription({this.jobId, this.type});
  @override
  _CandidateJobDescriptionState createState() =>
      _CandidateJobDescriptionState();
}

class _CandidateJobDescriptionState extends State<CandidateJobDescription> {
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
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.popAndPushNamed(context, "/");
                            },
                            child: Icon(Icons.refresh,
                                size: 40, color: Theme.blue)),
                        SizedBox(height: 10),
                        Text('Oops!! Something Went Wrong'),
                      ],
                    ),
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

  bool loading = false;

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
                  "Last Updated On - ${timeAgo(widget.singleJobDesc.updatedAt)}" ??
                      "Time",
                  style: Theme.black_textstyle,
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 5,
        onPressed: (widget.type != "appliedjobs" && !applied)
            ? () async {
                print("apply"); //
                //
                setState(() {
                  widget.loading = true;
                });
                //
                Map<String, dynamic> response =
                    await jobProvider.applyJob(widget.singleJobDesc.id);
                print("response - ${response}");
                //
                if (response["status"] == "success") {
                  print("success");
                  setState(() {
                    errors = {};
                    applied = true;
                  });
                } else {
                  print("failed");
                  setState(() {
                    errors = response["errors"];
                    applied = false;
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
                                if (errors["generalerror"].toString() ==
                                    "You are not authorized") {
                                  // authProvider.logout();
                                  Navigator.of(context).pop(false); //pop up
                                  // Navigator.pop(context); // Modal
                                  // Navigator.popAndPushNamed(
                                  //     context, "/SignIn"); // main page
                                } else {
                                  Navigator.of(context).pop(false);
                                }
                              },
                              type: "green",
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  setState(() {
                    widget.loading = false;
                  });
                }
              }
            : () {},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(35),
          ),
        ),
        label: Text(
          (widget.type == "appliedjobs")
              ? "  Already Applied  "
              : (applied)
                  ? "Applied Successfully"
                  : (widget.loading)
                      ? "       Loading ...       "
                      : "       Apply       ",
          style: Theme.white_textstyle,
        ),
      ),
      // for Applied Job
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
