import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Providers/JobProvider.dart';

import "../../Widgets/mytextbutton.dart";
import "../../Widgets/titletext.dart";
import "../../Widgets/errortext.dart";
import "../../Widgets/mycontainer.dart";
import "../../../Constansts/theme.dart" as Theme;
import '../../../Constansts/formfields.dart' as FormFields;
import '../../../Models/Job.dart';

import "../../Widgets/largebutton.dart";
import "../../UIHelpers/dailogs.dart";

class AddEditJobForm extends StatefulWidget {
  Data jobData;
  AddEditJobForm({this.jobData});
  bool loading = false;
  @override
  _AddEditJobFormState createState() => _AddEditJobFormState();
}

class _AddEditJobFormState extends State<AddEditJobForm> {
  //

  Map<String, dynamic> errors;
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedJobLocation;
  var jobProvider;
  Data jobdata = new Data(); // Job - Data

  //
  Future _showCloseDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext cx) {
        return AlertDialog(
          content: Text("Discard your changes?"),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          actions: <Widget>[
            MyTextButton(
              text: "Keep Editing",
              color: Colors.blueAccent,
              callback: () {
                Navigator.pop(context);
              },
            ),
            MyTextButton(
              text: "Discard",
              color: Colors.redAccent,
              callback: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  //
  @override
  void initState() {
    super.initState();
    jobProvider = Provider.of<JobProvider>(context, listen: false);
  }

  //
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _showCloseDialog();
        return;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Post New Job"),
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              size: 25,
            ),
            onPressed: () {
              _showCloseDialog();
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
                    SizedBox(height: 10),
                    Column(
                      children: [
                        TitleText(text: "Job Title"),
                        MyContainer(
                          child: TextFormField(
                            // maxLength: 10,
                            style: Theme.textfield_textstyle,
                            controller: _titleController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            decoration: new InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: "Please Enter Job Title",
                              hintStyle: Theme.hint_textfield_textstyle,
                            ),
                          ),
                        ),
                        if (errors != null)
                          ErrorText(text: errors["title"].toString()),
                      ],
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: [
                        TitleText(text: "Job Description"),
                        MyContainer(
                          child: TextFormField(
                            // maxLength: 10,
                            style: Theme.textfield_textstyle,
                            controller: _descController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            decoration: new InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: "Please Enter Job Description",
                              hintStyle: Theme.hint_textfield_textstyle,
                            ),
                          ),
                        ),
                        if (errors != null)
                          ErrorText(text: errors["description"].toString()),
                      ],
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: [
                        TitleText(text: "Job Location"),
                        MyContainer(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            underline: Container(color: Colors.transparent),
                            icon: Icon(Icons.keyboard_arrow_down),
                            hint: new Text(
                              _selectedJobLocation ??
                                  "Please Select Job Location",
                              style: (_selectedJobLocation != null)
                                  ? Theme.textfield_textstyle
                                  : Theme.hint_textfield_textstyle,
                            ),
                            items: FormFields.jobLocations
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,
                                      style: Theme.textfield_textstyle));
                            }).toList(),
                            onChanged: (selectedval) {
                              setState(() {
                                _selectedJobLocation = selectedval;
                              });
                            },
                          ),
                        ),
                        if (errors != null)
                          ErrorText(text: errors["location"].toString()),
                      ],
                    ),
                  ]),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          elevation: 5,
          onPressed: (!widget.loading)
              ? () async {
                  print("post job details");
                  jobdata.title = _titleController.text;
                  jobdata.description = _descController.text;
                  jobdata.location = _selectedJobLocation;

                  //
                  setState(() {
                    widget.loading = true;
                  });
                  //
                  Map<String, dynamic> response =
                      await jobProvider.createJob(jobdata);
                  print("create job - $response");
                  //
                  if (response["status"] == "success") {
                    print("success");
                    setState(() {
                      errors = {};
                    });
                    //
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text((widget.jobData == null)
                          ? 'New Job Posted Successfully'
                          : 'Job Post Edited Successfully'),
                      duration: Duration(seconds: 5),
                    ));
                    Navigator.popAndPushNamed(context, '/DashBoard');
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
                  setState(() {
                    widget.loading = false;
                  });
                  //
                }
              : () {},
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(35))),
          icon: Icon(Icons.save),
          label: Text(
              (widget.loading) ? "      Saving ...      " : "      Save      ",
              style: Theme.white_textstyle),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
