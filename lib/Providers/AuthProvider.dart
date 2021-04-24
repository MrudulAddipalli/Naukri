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
    var params = {
      "email": userdata.email,
      "password": userdata.password,
    };
    try {
      Response response = await _dio.post(url.login, data: params);

      if (response.statusCode == 200) {
        await setupSharedPreferencesForUser(response);
        return {"status": "success"};
      }
    } on DioError catch (errors) {
      if (errors.type == DioErrorType.other) {
        Map<String, dynamic> errorMap = {};
        errorMap
            .addAll({"generalerror": "Please Check Your Internet Connection"});
        return {
          "status": "failed",
          "errors": errorMap,
        };
      }
      // return ErrorHandler.returnError(errors);
    } catch (errors) {
      // return ErrorHandler.returnError(errors);
    }
  }

  Future<Map<String, dynamic>> forgetPassword({String email}) async {
    try {
      Response response =
          await _dio.get(url.resetpassword, queryParameters: {'email': email});
      var data = response.data["data"];
      return {"status": "success", "token": data["token"].toString()};
    } on DioError catch (errors) {
      if (errors.type == DioErrorType.other) {
        Map<String, dynamic> errorMap = {};
        errorMap
            .addAll({"generalerror": "Please Check Your Internet Connection"});
        return {
          "status": "failed",
          "errors": errorMap,
        };
      }
      // return ErrorHandler.returnError(errors);
    } catch (errors) {
      // return ErrorHandler.returnError(errors);
    }
  }

  Future<Map<String, dynamic>> confirmResetPassword(
      {String password, String confirmPassword, String token}) async {
    var params = {
      "password": password,
      "confirmPassword": confirmPassword,
      "token": token,
    };
    try {
      Response response = await _dio.post(url.resetpassword, data: params);
      if (response.statusCode == 200) {
        await setupSharedPreferencesForUser(response);
        return {"status": "success"};
      }
    } on DioError catch (errors) {
      if (errors.type == DioErrorType.other) {
        Map<String, dynamic> errorMap = {};
        errorMap
            .addAll({"generalerror": "Please Check Your Internet Connection"});
        return {
          "status": "failed",
          "errors": errorMap,
        };
      }
      // return ErrorHandler.returnError(errors);
    } catch (errors) {
      // return ErrorHandler.returnError(errors);
    }
  }

  Future<Map<String, dynamic>> signUp(User userdata) async {
    var params = {
      "userRole": userdata.userRole,
      "name": userdata.name,
      "email": userdata.email,
      "password": userdata.password,
      "confirmPassword": userdata.confirmpassword,
      "skills": (userdata.userRole == 1) ? "I am Recruiter" : userdata.skills,
    };

    print("params - $params");

    try {
      Response response = await _dio.post(url.register, data: params);
      //
      if (response.statusCode == 200) {
        await setupSharedPreferencesForUser(response);
        return {"status": "success"};
      }
    } on DioError catch (errors) {
      if (errors.type == DioErrorType.other) {
        Map<String, dynamic> errorMap = {};
        errorMap
            .addAll({"generalerror": "Please Check Your Internet Connection"});
        return {
          "status": "failed",
          "errors": errorMap,
        };
      }
      // return ErrorHandler.returnError(errors);
    } catch (errors) {
      // return ErrorHandler.returnError(errors);
    }
  }

  Future<void> setupSharedPreferencesForUser(Response response) async {
    User userdata = User.fromJson(response.data["data"]);
    _user = userdata; // local user
    _prefs = await SharedPreferences.getInstance();
    _prefs.setString("email", userdata.email);
    _prefs.setString("name", userdata.name);
    _prefs.setString("skills", userdata.skills);
    _prefs.setInt("userRole", userdata.userRole);
    _prefs.setString("createdAt", userdata.createdAt);
    _prefs.setString("updatedAt", userdata.updatedAt);
    _prefs.setString("id", userdata.id);
    _prefs.setString("token", userdata.token);
  }

  int resolveUserRole(String userRole) {
    if (userRole == "Recruiter") {
      return 1;
    } else if (userRole == "Candidate") {
      return 0;
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
