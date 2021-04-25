import 'package:flutter/material.dart';

import '../../../Models/User.dart';
import '../../../Utilities/Widgets/mainlogo.dart';
import '../../../Utilities/Widgets/badge.dart';
import '../../../../Constansts/theme.dart' as Theme;

class ApplicantDescription extends StatelessWidget {
  User userData;
  ApplicantDescription({this.userData});

  List<Widget> skills() {
    List<Widget> skills = [];
    userData.skills.split(", ").forEach((skill) {
      skills.add(Badge(
        skill ?? "",
        Colors.green,
      ));
    });
    return skills;
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
                            userData.name ?? "User Name",
                            textAlign: TextAlign.start,
                            style: Theme.title_textfield_textstyle_25,
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.email_outlined,
                                color: Colors.grey,
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text(
                                    userData.email ?? "User Email",
                                    softWrap: true,
                                    maxLines: 2,
                                    style: Theme.black_textstyle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: MainLogo(imagepath: "assets/images/person.png"),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Divider(thickness: 2),
                SizedBox(height: 10),
                Text(
                  "Skills",
                  style: Theme.bold_black_textstyle,
                ),
                SizedBox(height: 10),
                Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Wrap(
                      children: skills(),
                    )),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
