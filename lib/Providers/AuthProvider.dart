import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../Models/User.dart';
import '../Constansts/urls.dart' as url;
import '../Class/dio.dart';

class AuthProvider with ChangeNotifier {
  User _user;
  SharedPreferences _prefs;
  DIO _diohelper = DIO.getInstance;
  Dio _dio = DIO.getDioInstance;

  User get loggedInUser {
    return _user;
  }

  Future<bool> autoSignIn() async {
    // ///
    // return false;
    // //
    _prefs = await SharedPreferences.getInstance();
    final String token = _prefs.getString("token");
    print("stored token in autosignin- $token");

    // token exists - user can be autosigned in
    if (token != null) {
      User user = User(
        email: _prefs.getString("email"),
        name: _prefs.getString("name"),
        skills: _prefs.getString("skills"),
        userRole: _prefs.getInt("userRole"),
        createdAt: _prefs.getString("createdAt"),
        updatedAt: _prefs.getString("updatedAt"),
        id: _prefs.getString("id"),
        token: _prefs.getString("token"),
      );
      _user = user;
      print(user.email);
      return true;
    }
    // starting app for first time
    return false;
  }

  Future<Map<String, dynamic>> signIn(User userdata) async {
    // await Future.delayed(Duration(hours: 1));
    var params = {
      "email": userdata.email,
      "password": userdata.password,
    };
    return _diohelper.apiCall(steps: () async {
      Response response = await _dio.post(url.login, data: params);
      if (response.statusCode == 200) {
        await setupSharedPreferencesForUser(response);
        return {"status": "success"};
      }
    });
  }

  Future<Map<String, dynamic>> forgetPassword({String email}) async {
    return _diohelper.apiCall(steps: () async {
      Response response =
          await _dio.get(url.resetpassword, queryParameters: {'email': email});
      var data = response.data["data"];
      return {"status": "success", "token": data["token"].toString()};
    });
  }

  Future<Map<String, dynamic>> confirmResetPassword(
      {String password, String confirmPassword, String token}) async {
    var params = {
      "password": password,
      "confirmPassword": confirmPassword,
      "token": token,
    };
    return _diohelper.apiCall(steps: () async {
      Response response = await _dio.post(url.resetpassword, data: params);
      if (response.statusCode == 200) {
        await setupSharedPreferencesForUser(response);
        return {"status": "success"};
      }
    });
  }

  Future<Map<String, dynamic>> signUp(User userdata) async {
    var params = {
      "userRole": userdata.userRole,
      "name": userdata.name,
      "email": userdata.email,
      "password": userdata.password,
      "confirmPassword": userdata.confirmpassword,
      "skills": (userdata.userRole == 0) ? "I am Recruiter" : userdata.skills,
    };
    return _diohelper.apiCall(steps: () async {
      Response response = await _dio.post(url.register, data: params);
      if (response.statusCode == 200) {}
      await setupSharedPreferencesForUser(response);
      return {"status": "success"};
    });
  }

  Future<void> setupSharedPreferencesForUser(Response response) async {
    User userdata = User.fromJson(response.data["data"]);
    _user = userdata; // local user
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setString("email", userdata.email);
    await _prefs.setString("name", userdata.name);
    await _prefs.setString("skills", userdata.skills);
    await _prefs.setInt("userRole", userdata.userRole);
    await _prefs.setString("createdAt", userdata.createdAt);
    await _prefs.setString("updatedAt", userdata.updatedAt);
    await _prefs.setString("id", userdata.id);
    await _prefs.setString("token", userdata.token);
  }

  int resolveUserRole(String userRole) {
    if (userRole == "Recruiter") {
      return 0;
    } else if (userRole == "Candidate") {
      return 1;
    }
  }

  String resolveSkills(Map<String, bool> skills) {
    String strSkills = "";
    skills.forEach((skillname, value) {
      if (value == true) strSkills += "$skillname, ";
    });
    return (strSkills != "")
        ? "${strSkills.substring(0, strSkills.length - 2)}."
        : null;
  }

  Future<bool> logout() async {
    print("logout");
    _prefs = await SharedPreferences.getInstance();
    _prefs.remove("email");
    _prefs.remove("name");
    _prefs.remove("skills");
    _prefs.remove("userRole");
    _prefs.remove("createdAt");
    _prefs.remove("updatedAt");
    _prefs.remove("id");
    await _prefs.remove("token");
    return true;
  }
}
