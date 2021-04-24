import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/AuthProvider.dart';
import '../Models/User.dart';

import "../Utilities/UIHelpers/dailogs.dart";

import '../Utilities/Widgets/mycontainer.dart';
import '../Utilities/Widgets/largebutton.dart';
import '../Utilities/Widgets/mytitle.dart';
import '../Utilities/Widgets/titletext.dart';
import '../Utilities/Widgets/mainlogo.dart';
import '../Utilities/Widgets/bluetext.dart';
import '../../Utilities/Widgets/errortext.dart';
import '../../Constansts/theme.dart' as Theme;
import '../../Constansts/formfields.dart' as FormFields;

class SignUp extends StatefulWidget {
  bool loading = false;

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var authProvider;
  String selectedUserRole;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  bool showPassword = false;
  bool showConfirmPassword = false;
  bool showSkills = false;
  Map<String, bool> selectedSkills = {};
  Map<String, dynamic> errors;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    setupSkills();
  }

  void setupSkills() {
    FormFields.skills.forEach((skill) {
      selectedSkills.addAll({"$skill": false});
    });
  }

  @override
  Widget build(BuildContext context) {
    //
    //
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (context, constraint) {
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    MainLogo(),
                    SizedBox(height: 10),
                    MyTitle(text: "Create Your Account"),
                    BlueText(text: "Sign up using your email"),
                    SizedBox(height: 30),
                    Container(
                      width: (constraint.maxWidth < 450)
                          ? constraint.maxWidth * 0.9
                          : 400,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 10),
                          Column(
                            children: [
                              TitleText(text: "I am?"),
                              MyContainer(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  underline:
                                      Container(color: Colors.transparent),
                                  icon: Icon(Icons.keyboard_arrow_down),
                                  hint: new Text(
                                    selectedUserRole ?? "Select User Type",
                                    style: Theme.textfield_textstyle,
                                  ),
                                  items: FormFields.userroles
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: Theme.textfield_textstyle,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (selectedval) {
                                    if (selectedval == "Candidate") {
                                      showSkills = true;
                                      setupSkills();
                                    } else {
                                      showSkills = false;
                                      setupSkills(); //making all null
                                    }
                                    setState(() {
                                      selectedUserRole = selectedval;
                                    });
                                  },
                                ),
                              ),
                              if (errors != null)
                                ErrorText(text: errors["userRole"].toString()),
                            ],
                          ),
                          Column(
                            children: [
                              MyContainer(
                                child: TextFormField(
                                  // maxLength: 10,
                                  style: Theme.textfield_textstyle,
                                  controller: _nameController,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.name,
                                  decoration: new InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintText: "Please Enter Name",
                                    hintStyle: Theme.textfield_textstyle,
                                  ),
                                ),
                              ),
                              if (errors != null)
                                ErrorText(text: errors["name"].toString()),
                            ],
                          ),
                          Column(
                            children: [
                              MyContainer(
                                child: TextFormField(
                                  // maxLength: 10,
                                  style: Theme.textfield_textstyle,
                                  controller: _emailController,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: new InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintText: "Please Enter Email",
                                    hintStyle: Theme.textfield_textstyle,
                                  ),
                                ),
                              ),
                              if (errors != null)
                                ErrorText(text: errors["email"].toString()),
                            ],
                          ),
                          Column(
                            children: [
                              MyContainer(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 9,
                                      child: TextFormField(
                                        // maxLength: 10,
                                        style: Theme.textfield_textstyle,
                                        controller: _passController,
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.text,
                                        obscureText: !showPassword,
                                        decoration: new InputDecoration(
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          hintText: "Please Enter Password",
                                          hintStyle: Theme.textfield_textstyle,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            showPassword = !showPassword;
                                          });
                                        },
                                        child: Container(
                                          height: 20,
                                          width: 20,
                                          child: Center(
                                            child: Image(
                                              image: AssetImage((showPassword)
                                                  ? 'assets/images/open_eye.png'
                                                  : 'assets/images/hide_eye.png'),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (errors != null)
                                ErrorText(text: errors["password"].toString()),
                            ],
                          ),

                          Column(
                            children: [
                              MyContainer(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 9,
                                      child: TextFormField(
                                        // maxLength: 10,
                                        style: Theme.textfield_textstyle,
                                        controller: _confirmPassController,
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.text,
                                        obscureText: !showConfirmPassword,
                                        decoration: new InputDecoration(
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          hintText:
                                              "Please Enter Confirm Password",
                                          hintStyle: Theme.textfield_textstyle,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            showConfirmPassword =
                                                !showConfirmPassword;
                                          });
                                        },
                                        child: Container(
                                          height: 20,
                                          width: 20,
                                          child: Center(
                                            child: Image(
                                              image: AssetImage((showConfirmPassword)
                                                  ? 'assets/images/open_eye.png'
                                                  : 'assets/images/hide_eye.png'),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (errors != null)
                                ErrorText(
                                    text: errors["confirmPassword"].toString()),
                            ],
                          ),
                          //
                          // Please select your skills from below
                          if (showSkills)
                            Column(
                              children: [
                                SizedBox(height: 10),
                                TitleText(
                                    text: "Select your skills from below"),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      width: 2,
                                      color: Theme.grey_border,
                                    ),
                                    color: Theme.grey_bg_1,
                                  ),
                                  child: GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: FormFields.skills.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio:
                                          constraint.maxWidth / 90,
                                      crossAxisCount: 2,
                                    ),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      List<String> skill = FormFields.skills;

                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedSkills["${skill[index]}"] =
                                                !selectedSkills[
                                                    "${skill[index]}"];
                                          });
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            (selectedSkills[
                                                        "${skill[index]}"] ==
                                                    false)
                                                ? Icon(
                                                    Icons.check_circle,
                                                    color: Theme.grey_border,
                                                  )
                                                : Icon(
                                                    Icons.check_circle,
                                                    color: Theme.blue,
                                                  ),
                                            SizedBox(width: 10),
                                            Text(
                                              "${skill[index]}",
                                              style: Theme.textfield_textstyle,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                if (errors != null)
                                  ErrorText(text: errors["skills"].toString()),
                              ],
                            ),

                          //
                          //
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 30, 0, 30),
                            child: LargeButton(
                              text: (!widget.loading) ? "Sign Up" : "Loading",
                              callback: () async {
                                setState(() {
                                  widget.loading = true;
                                });
                                //
                                int role = authProvider
                                    .resolveUserRole(selectedUserRole);
                                String userSkills =
                                    authProvider.resolveSkills(selectedSkills);
                                print("userSkills - $userSkills");

                                // checking skills for candidate

                                if (role == 0 &&
                                    (userSkills.toString() == "" ||
                                        userSkills == null)) {
                                  print(
                                      "-------------------------------------------------Error ----------------------------------------------------------------");
                                  errors.addAll(
                                      {"skills": "Please Select Your Skills"});
                                }
                                setState(() {});
                                //

                                User userdata = User(
                                  userRole: role,
                                  name: _nameController.text,
                                  email: _emailController.text,
                                  password: _passController.text,
                                  confirmpassword: _confirmPassController.text,
                                  skills: userSkills,
                                );
                                //
                                Map<String, dynamic> response =
                                    await authProvider.signUp(userdata);
                                //
                                if (response["status"] == "success") {
                                  print("success - goto main page");
                                  setState(() {
                                    if (role == 0 &&
                                        (userSkills.toString() == "" ||
                                            userSkills == null)) {
                                      errors.addAll({
                                        "skills": "Please Select Your Skills"
                                      });
                                    } else {
                                      errors = null;
                                      Navigator.popAndPushNamed(
                                          context, '/DashBoard');
                                    }
                                  });
                                } else {
                                  print("failed");
                                  setState(() {
                                    errors = response["errors"];
                                    if (role == 0 &&
                                        (userSkills.toString() == "" ||
                                            userSkills == null)) {
                                      errors.addAll({
                                        "skills": "Please Select Your Skills"
                                      });
                                    }
                                  });

                                  if (errors["generalerror"].toString() !=
                                      "null") {
                                    bool status =
                                        await Dialogs.getInstance.confirmDialog(
                                      context: context,
                                      title: "Alert",
                                      subtitle: errors["generalerror"],
                                      actions: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: LargeButton(
                                              text: "Cancel",
                                              callback: () {
                                                Navigator.of(context)
                                                    .pop(false);
                                              },
                                              type: "green",
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(""),
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: LargeButton(
                                              text: "SignIn",
                                              callback: () {
                                                Navigator.of(context).pop(true);
                                              },
                                              type: "green",
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                    print("status $status");
                                    if (status) {
                                      // proceed to sign up
                                      Navigator.popAndPushNamed(
                                          context, "/SingIn");
                                    }
                                  }
                                  // } // amin error failed else part
                                }
                                //
                                setState(() {
                                  widget.loading = false;
                                });
                                //
                              },
                              type: "blue",
                            ),
                          ),
                          //
                          //
                          if (widget.loading) SizedBox(height: 10),
                          if (widget.loading) CircularProgressIndicator(),
                          if (widget.loading) SizedBox(height: 10),
                          //
                          //
                          Wrap(
                            children: [
                              Text(
                                "Already have an account?",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.popAndPushNamed(context, '/SignIn');
                                },
                                child: Text(
                                  " Sign in",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.bluetext,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
