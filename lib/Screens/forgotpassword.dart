import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/AuthProvider.dart';

import "../Utilities/UIHelpers/dailogs.dart";

import '../Utilities/Widgets/mycontainer.dart';
import '../Utilities/Widgets/largebutton.dart';
import '../Utilities/Widgets/mytitle.dart';
import '../Utilities/Widgets/backiconbutton.dart';
import '../Utilities/Widgets/mainlogo.dart';
import '../../Utilities/Widgets/errortext.dart';
import '../../Constansts/theme.dart' as Theme;

class ForgotPassWord extends StatefulWidget {
  bool loading = false;

  @override
  _ForgotPassWordState createState() => _ForgotPassWordState();
}

class _ForgotPassWordState extends State<ForgotPassWord> {
  //
  bool clickedResetPassword = false;
  //
  var authProvider;
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  String token;
  bool showPassword = false;
  bool showConfirmPassword = false;
  Map<String, dynamic> errors;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    //
    //
    Future passwordResetConfirmationModal() {
      return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext cx) {
          return AlertDialog(
            content: Container(
              height: 450,
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock,
                    size: 170,
                    color: Theme.blue,
                  ),
                  Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Your password has been reset successfully.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  LargeButton(
                    text: "Thank You",
                    callback: () {
                      // Navigator.of(context)
                      //     .popUntil(ModalRoute.withName('/SignUp'));

                      Navigator.pop(
                          context); // Your password has been reset successfully.
                      Navigator.pop(context); // Forgot Password
                    },
                    type: "blue",
                  ),
                ],
              ),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          );
        },
      );
    }

    //
    void resetPasswordConfirmed() async {
      Map<String, dynamic> response = await authProvider.confirmResetPassword(
        password: _passController.text,
        confirmPassword: _confirmPassController.text,
        token: token,
      );

      if (response["status"] == "success") {
        print("success");
        setState(() {
          errors = {};
        });
        await passwordResetConfirmationModal();
      } else {
        print("failed");
        setState(() {
          errors = response["errors"];
        });
        // invalid token
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
                    text: "Try Again",
                    callback: () {
                      Navigator.of(context).pop(true);
                      setState(() {
                        clickedResetPassword = false;
                        token = null;
                      });
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
    }

    //
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraint) {
            return Stack(
              children: [
                Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 50),
                        MainLogo(),
                        SizedBox(height: 10),
                        MyTitle(text: "Reset Your Password"),
                        SizedBox(height: 30),
                        Container(
                          width: (constraint.maxWidth < 450)
                              ? constraint.maxWidth * 0.9
                              : 400,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 10),
                              if (!clickedResetPassword)
                                Column(
                                  children: [
                                    MyContainer(
                                      child: TextFormField(
                                        // maxLength: 10,
                                        style: Theme.textfield_textstyle,
                                        controller: _emailController,
                                        textInputAction: TextInputAction.next,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: new InputDecoration(
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          hintText: "Please Enter Email",
                                          hintStyle:
                                              Theme.hint_textfield_textstyle,
                                        ),
                                      ),
                                    ),
                                    if (errors != null)
                                      ErrorText(
                                          text: errors["email"].toString()),
                                  ],
                                ),
                              if (clickedResetPassword)
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
                                              textInputAction:
                                                  TextInputAction.next,
                                              keyboardType: TextInputType.text,
                                              obscureText: !showPassword,
                                              decoration: new InputDecoration(
                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                disabledBorder:
                                                    InputBorder.none,
                                                hintText: "Enter New Password",
                                                hintStyle:
                                                    Theme.textfield_textstyle,
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
                                      ErrorText(
                                          text: errors["password"].toString()),
                                  ],
                                ),
                              if (clickedResetPassword)
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
                                              controller:
                                                  _confirmPassController,
                                              textInputAction:
                                                  TextInputAction.next,
                                              keyboardType: TextInputType.text,
                                              obscureText: !showConfirmPassword,
                                              decoration: new InputDecoration(
                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                disabledBorder:
                                                    InputBorder.none,
                                                hintText:
                                                    "Confirm New Password",
                                                hintStyle:
                                                    Theme.textfield_textstyle,
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
                                                    image: AssetImage(
                                                        (showConfirmPassword)
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
                                          text: errors["confirmPassword"]
                                              .toString()),
                                  ],
                                ),

                              // first button
                              if (!clickedResetPassword)
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 30, 0, 30),
                                  child: LargeButton(
                                    text: (!widget.loading)
                                        ? "Reset Password"
                                        : "Loading",
                                    callback: () async {
                                      setState(() {
                                        widget.loading = true;
                                      });
                                      Map<String, dynamic> response =
                                          await authProvider.forgetPassword(
                                              email: _emailController.text);

                                      if (response["status"] == "success") {
                                        print("success");

                                        setState(() {
                                          clickedResetPassword = true;
                                          token = response["token"];
                                          errors = {};
                                        });
                                      } else {
                                        print("failed");
                                        setState(() {
                                          errors = response["errors"];
                                        });
                                      }

                                      //
                                      if (errors["generalerror"].toString() !=
                                          "null") {
                                        bool status = await Dialogs.getInstance
                                            .confirmDialog(
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
                                            ],
                                          ),
                                        );
                                      }
                                      setState(() {
                                        widget.loading = false;
                                      });
                                    },
                                    type: "blue",
                                  ),
                                ),
                              //
                              //
                              //second button
                              if (clickedResetPassword)
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 30, 0, 30),
                                  child: LargeButton(
                                    text: (!widget.loading)
                                        ? "Confirm Reset Password"
                                        : "Loading",
                                    callback: () async {
                                      bool status = await Dialogs.getInstance
                                          .confirmDialog(
                                        context: context,
                                        title: "Are you sure?",
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
                                                text: "Yes",
                                                callback: () {
                                                  Navigator.of(context)
                                                      .pop(true);
                                                },
                                                type: "green",
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                      print("status $status");
                                      if (status) {
                                        resetPasswordConfirmed();
                                      }
                                    },
                                    type: "blue",
                                  ),
                                ),
                              SizedBox(height: 50),
                              LargeButton(
                                text: "Cancel",
                                callback: () {
                                  Navigator.of(context).pop();
                                },
                                type: "grey",
                              ),
                              SizedBox(height: 50),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                BackIconButton(),
              ],
            );
          },
        ),
      ),
    );
  }
}
