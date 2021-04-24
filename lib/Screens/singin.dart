import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/AuthProvider.dart';
import '../Models/User.dart';

import "../Utilities/UIHelpers/dailogs.dart";

import '../../Utilities/Widgets/mycontainer.dart';
import '../../Utilities/Widgets/largebutton.dart';
import '../../Utilities/Widgets/mytitle.dart';
import '../../Utilities/Widgets/mainlogo.dart';
import '../../Utilities/Widgets/bluetext.dart';
import '../../Utilities/Widgets/errortext.dart';
import '../../Constansts/theme.dart' as Theme;

class SignIn extends StatefulWidget {
  bool loading = false;
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  //
  var authProvider;
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool showPassword = false;
  Map<String, dynamic> errors = {};

  //
  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    SizedBox(height: 80),
                    MainLogo(),
                    SizedBox(height: 10),
                    MyTitle(text: "Welcome!"),
                    BlueText(text: "Sign in to access your account"),
                    SizedBox(height: 50),
                    Container(
                      width: (constraint.maxWidth < 450)
                          ? constraint.maxWidth * 0.9
                          : 400,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
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
                                    hintText: "Email",
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
                                          hintText: "Password",
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
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 10, 15, 10),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/ForgotPassword');
                                  },
                                  child: BlueText(text: "Forgot Password?"),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 30, 0, 30),
                            child: LargeButton(
                              text: (!widget.loading) ? "Sign In" : "Loading",
                              callback: () async {
                                setState(() {
                                  widget.loading = true;
                                });
                                //
                                User userdata = User(
                                  email: _emailController.text,
                                  password: _passController.text,
                                );
                                //
                                Map<String, dynamic> response =
                                    await authProvider.signIn(userdata);
                                //
                                if (response["status"] == "success") {
                                  print("success");
                                  setState(() {
                                    errors = {};
                                  });

                                  //
                                  Navigator.popAndPushNamed(
                                      context, '/DashBoard');
                                  //
                                } else {
                                  print("failed");
                                  setState(() {
                                    errors = response["errors"];
                                  });

                                  //
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
                                        ],
                                      ),
                                    );
                                  }
                                }
                                setState(() {
                                  widget.loading = false;
                                });
                              },
                              type: "blue",
                            ),
                          ),
                          if (widget.loading) SizedBox(height: 20),
                          if (widget.loading) CircularProgressIndicator(),
                          SizedBox(height: 80),
                          Wrap(
                            children: [
                              Text(
                                "Not Registered Yet?",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  print("signup");
                                  Navigator.pushNamed(context, "/SignUp");
                                },
                                child: Text(
                                  " Sign Up",
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
