import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import "../../../Providers/JobProvider.dart";
import "../../UIHelpers/dailogs.dart";
import "../../Widgets/largebutton.dart";
import "../../UIHelpers/modalhelper.dart";
import '../../../Models/User.dart';
import '../../../../Utilities/Widgets/mainlogo.dart';
import '../../../../Constansts/theme.dart' as Theme;
import "../../Widgets/Recruiter/applicantdescription.dart";

class ApplicantListForJobID extends StatefulWidget {
  String jobId;
  ApplicantListForJobID({this.jobId});
  @override
  ApplicantListForJobIDState createState() => ApplicantListForJobIDState();
}

class ApplicantListForJobIDState extends State<ApplicantListForJobID> {
  var jobProvider;
  Map<String, dynamic> errors;
  List<User> usersData; // Job -> Data

  @override
  void initState() {
    super.initState();
    jobProvider = Provider.of<JobProvider>(context, listen: false);
    () async {
      await getApplicantDetails();
    }();
  }

  getApplicantDetails() async {
    Map<String, dynamic> response =
        await jobProvider.getApplicantListForJobID(widget.jobId);
    if (response["status"] == "success") {
      print("success - show job data");
      setState(() {
        errors = null;
        usersData = response["usersData"];
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 5,
          title: Text("Candidates Screen"),
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
        backgroundColor: Colors.white,
        body: SafeArea(
          child: (usersData == null)
              ? Center(
                  child: (errors == null)
                      ? CircularProgressIndicator()
                      : Text('Oops!! Something Went Wrong'),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      usersData = null;
                      errors = null;
                      getApplicantDetails();
                    });
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (usersData.length > 0)
                          Column(
                            children: [
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Text(
                                      "Total Candidate(s) - ${usersData.length}",
                                      style: Theme.blue_textstyle,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: usersData.length + 1,
                            itemBuilder: (context, i) {
                              //
                              if (i == usersData.length) {
                                return Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: 80,
                                    padding:
                                        EdgeInsets.fromLTRB(20, 20, 20, 20),
                                    child: Text(
                                      (i == 0)
                                          ? "No Candidate Applied For This Job"
                                          : "Reached End",
                                      style: Theme.black_textstyle,
                                    ),
                                  ),
                                );
                              }
                              //

                              User user = usersData[i];

                              return Container(
                                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Material(
                                  borderRadius: BorderRadius.circular(15),
                                  elevation: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          width: 2, color: Theme.grey_border),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                          child: ListTile(
                                            onTap: () {
                                              ModalHelper.getInstance.show(
                                                context,
                                                ApplicantDescription(
                                                    userData: user),
                                              );
                                            },
                                            leading: SizedBox(
                                              height: 80,
                                              width: 60,
                                              child: MainLogo(
                                                  imagepath:
                                                      "assets/images/person.png",
                                                  height: 50,
                                                  width: 50),
                                            ),
                                            title: Text(
                                              user.name ?? "User Name",
                                              style:
                                                  Theme.black_textstyle_18_bold,
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 5),
                                                Text(
                                                  user.email ?? "User Email",
                                                  softWrap: true,
                                                  maxLines: 2,
                                                  style: Theme.black_textstyle,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
