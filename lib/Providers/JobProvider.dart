import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Class/dio.dart';
import '../Models/User.dart';
import '../Models/Job.dart';
import '../Constansts/urls.dart' as url;

class JobProvider with ChangeNotifier {
  User _user;
  SharedPreferences _prefs;
  DIO _diohelper = DIO.getInstance;
  Dio _dio = DIO.getDioInstance;

  set(User loggedInUser) {
    _user = loggedInUser;
  }

  Future<Map<String, dynamic>> getAllJobs() async {
    return _diohelper.apiCall(steps: () async {
      Response response = await _dio.get(url.allJobs);
      Job jobData = Job.fromJson(response.data);
      return {"status": "success", "jobData": jobData};
    });
  }

  Future<Map<String, dynamic>> jobDescriptionFor(String jobId) async {
    return _diohelper.apiCall(steps: () async {
      Response response = await _dio.get("${url.allJobs}/$jobId");
      Data jobData = Data.fromJson(response.data["data"]);
      return {"status": "success", "singleJobDesc": jobData};
    });
  }

  // Future<Map<String, dynamic>> getAllJobs() async {
  //   try {
  // //
  // Response response = await _dio.get(url.allJobs);
  // //
  // Job jobData = Job.fromJson(response.data);
  // return {"status": "success", "jobData": jobData};
  // //
  //   } on DioError catch (errors) {
  //     if (errors.type == DioErrorType.other) {
  //       Map<String, dynamic> errorMap = {};
  //       errorMap
  //           .addAll({"generalerror": "Please Check Your Internet Connection"});
  //       return {
  //         "status": "failed",
  //         "errors": errorMap,
  //       };
  //     }
  //     return ErrorHandler.returnError(errors);
  //   } catch (errors) {
  //     return ErrorHandler.returnError(errors);
  //   }
  // }

  // Future<Map<String, dynamic>> jobDescriptionFor(String jobId) async {
  //   try {
  // Response response = await _dio.get("${url.allJobs}/$jobId");
  // Data jobData = Data.fromJson(response.data["data"]);
  // return {"status": "success", "singleJobDesc": jobData};
  //     //
  //   } on DioError catch (errors) {
  //     if (errors.type == DioErrorType.other) {
  //       Map<String, dynamic> errorMap = {};
  //       errorMap
  //           .addAll({"generalerror": "Please Check Your Internet Connection"});
  //       return {
  //         "status": "failed",
  //         "errors": errorMap,
  //       };
  //     }
  //     return ErrorHandler.returnError(errors);
  //   } catch (errors) {
  //     return ErrorHandler.returnError(errors);
  //   }
  // }
}
