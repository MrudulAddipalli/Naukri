import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Providers/AuthProvider.dart';
import '../../Providers/JobProvider.dart';
import '../../Models/User.dart';
import '../../Models/Job.dart';

import '../UIHelpers/datetimehelper.dart';
import '../UIHelpers/modalhelper.dart';
import '../../Utilities/Widgets/mainlogo.dart';
import '../../Constansts/theme.dart' as Theme;

import '../../Screens/jobdescription.dart';

class CandidateJobList extends StatefulWidget {
  Job jobs;
  CandidateJobList({this.jobs});
  @override
  CandidateJobListState createState() => CandidateJobListState();
}

class CandidateJobListState extends State<CandidateJobList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.jobs.data.length,
        itemBuilder: (context, i) {
          Data job = widget.jobs.data[i];

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
                  border: Border.all(width: 2, color: Theme.grey_border),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: ListTile(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.place),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 0, 0),
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.lock_clock_outlined),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 0, 0),
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
                          InkWell(
                            onTap: () {
                              ModalHelper.getInstance
                                  .show(context, JobDescription(jobId: job.id));
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
        });
  }
}
