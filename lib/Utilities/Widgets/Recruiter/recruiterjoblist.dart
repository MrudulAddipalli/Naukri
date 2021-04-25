import 'package:flutter/material.dart';

import '../../../Models/Job.dart';
import "../../UIHelpers/datetimehelper.dart";
import "../../UIHelpers/modalhelper.dart";
import '../../../../Utilities/Widgets/mainlogo.dart';
import '../../../../Constansts/theme.dart' as Theme;
import "../../Widgets/Recruiter/recruiterjobdescription.dart";
import "../../Widgets/Recruiter/applicantlistforjob.dart";

class RecruiterJobList extends StatefulWidget {
  List<Data> jobData;
  String type;
  RecruiterJobList({this.jobData, this.type});
  @override
  RecruiterJobListState createState() => RecruiterJobListState();
}

class RecruiterJobListState extends State<RecruiterJobList> {
  @override
  Widget build(BuildContext context) {
    return (widget.jobData == null)
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                  onTap: () {
                    Navigator.popAndPushNamed(context, "/");
                  },
                  child: Icon(Icons.refresh, size: 40, color: Theme.blue)),
              SizedBox(height: 10),
              Text('Oops!! Something Went Wrong'),
            ],
          )
        : SingleChildScrollView(
            child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.jobData.length + 1,
                itemBuilder: (context, i) {
                  if (i == widget.jobData.length) {
                    return Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 80,
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: Text(
                          (i == 0)
                              ? "No Jobs Posted"
                              : "No More Job's Found, Reached End",
                          style: Theme.black_textstyle,
                        ),
                      ),
                    );
                  }

                  Data job = widget.jobData[i];

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
                          border:
                              Border.all(width: 2, color: Theme.grey_border),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: ListTile(
                                onTap: (widget.type == "appliedjobs")
                                    ? () {
                                        print("ApplicantListForJobID");

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ApplicantListForJobID(
                                              jobId: job.id,
                                            ),
                                          ),
                                        );
                                        // ModalHelper.getInstance.full(
                                        //   context,
                                        // ApplicantListForJobID(
                                        //   jobId: job.id,
                                        // ),
                                        // );
                                      }
                                    : () {
                                        ModalHelper.getInstance.show(
                                          context,
                                          RecruiterJobDescription(
                                              jobId: job.id, type: widget.type),
                                        );
                                      },
                                leading: SizedBox(
                                  height: 80,
                                  width: 60,
                                  child: MainLogo(height: 50, width: 50),
                                ),
                                title: Text(
                                  job.title ?? "Job Title",
                                  style: Theme.black_textstyle_18_bold,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 5),
                                    Text(
                                      job.description ?? "Job Description",
                                      softWrap: true,
                                      maxLines: 2,
                                      style: Theme.black_textstyle,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            //Date Time Location Apply
                            Container(
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.zero,
                                  topRight: Radius.zero,
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                ),
                                color: Theme.grey_bg,
                              ),
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.place,
                                            color: Colors.grey,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: Text(
                                              job.location ?? "Job Location",
                                              softWrap: true,
                                              maxLines: 2,
                                              style: Theme.black_textstyle,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.lock_clock_outlined,
                                            color: Colors.grey,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: Text(
                                              timeAgo(job.updatedAt ?? "Time"),
                                              softWrap: true,
                                              maxLines: 2,
                                              style: Theme.black_textstyle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  //Apply Button
                                  (widget.type == "appliedjobs")
                                      ? InkWell(
                                          onTap: () {
                                            print("ApplicantListForJobID");
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ApplicantListForJobID(
                                                  jobId: job.id,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                  Icons.account_circle_rounded),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "View All Applicants",
                                                  style: Theme.black_textstyle,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            ModalHelper.getInstance.show(
                                                context,
                                                RecruiterJobDescription(
                                                    jobId: job.id,
                                                    type: widget.type));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Know More",
                                              style: Theme.black_textstyle,
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          );
  }
}
