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
      if (response.statusCode == 200) {
        List<Data> data = [];
        response.data["data"].forEach((v) {
          data.add(new Data.fromJson(v));
        });
        return {"status": "success", "jobData": data};
      }
    });
  }

  Future<Map<String, dynamic>> getAllRecruiterPostedJobs() async {
    _prefs = await SharedPreferences.getInstance();
    String token = _prefs.getString("token");
    return _diohelper.apiCall(steps: () async {
      _dio.options.headers = {"Authorization": token};
      Response response = await _dio.get(url.recruiterJobs);
      if (response.statusCode == 200) {
        List<Data> data = [];
        // Job Data
        if (response.data != null &&
            response.data["data"] != null &&
            response.data["data"]["data"] != null) {
          response.data["data"]["data"].forEach((v) {
            print(v);
            data.add(new Data.fromJson(v));
          });
        }
        // No Jobs Posted Message
        else if (response.data != null && response.data["data"] != null) {
          response.data["data"].forEach((v) {
            data.add(new Data.fromJson(v));
          });
        }

        return {"status": "success", "jobData": data};
      }
    });
  }

  Future<Map<String, dynamic>> getApplicantListForJobID(String jobId) async {
    _prefs = await SharedPreferences.getInstance();
    String token = _prefs.getString("token");
    return _diohelper.apiCall(steps: () async {
      _dio.options.headers = {"Authorization": token};
      Response response =
          await _dio.get("${url.recruiterJobs}/$jobId/candidates");
      if (response.statusCode == 200) {
        List<User> usersData = [];
        // Candidate User Data
        if (response.data != null && response.data["data"] != null) {
          response.data["data"].forEach((v) {
            usersData.add(new User.fromJson(v));
          });
        }
        return {"status": "success", "usersData": usersData};
      }
    });
  }

  Future<Map<String, dynamic>> deleteJob(String jobId) async {
    _prefs = await SharedPreferences.getInstance();
    String token = _prefs.getString("token");
    var params = {"jobId": jobId};
    //
    return _diohelper.apiCall(steps: () async {
      _dio.options.headers = {"Authorization": token};
      Response response = await _dio.delete(url.allJobs, data: params);
      if (response.statusCode == 200) {}
      return {"status": "success"};
    });
  }

  // Job - Data
  Future<Map<String, dynamic>> createJob(Data jobData) async {
    var params = jobData.toJson();
    return _diohelper.apiCall(steps: () async {
      Response response = await _dio.post(url.createJob, data: params);
      print(response);
      if (response.statusCode == 200) {}
      return {"status": "success"};
    });
  }

  Future<Map<String, dynamic>> getAllCandidateJobs() async {
    _prefs = await SharedPreferences.getInstance();
    String token = _prefs.getString("token");
    return _diohelper.apiCall(steps: () async {
      _dio.options.headers = {"Authorization": token};
      Response response = await _dio.get(url.candidateJobs);
      if (response.statusCode == 200) {
        List<Data> data = [];
        if (response.data != null && response.data["data"] != null) {
          response.data["data"].forEach((v) {
            data.add(new Data.fromJson(v));
          });
        }

        return {"status": "success", "jobData": data};
      }
    });
  }

  Future<Map<String, dynamic>> getAllCandidateAppliedJobs() async {
    _prefs = await SharedPreferences.getInstance();
    String token = _prefs.getString("token");
    return _diohelper.apiCall(steps: () async {
      _dio.options.headers = {"Authorization": token};
      Response response = await _dio.get(url.candidateAppliedJobs);
      if (response.statusCode == 200) {
        List<Data> data = [];
        response.data["data"].forEach((v) {
          data.add(new Data.fromJson(v));
        });
        return {"status": "success", "jobData": data};
      }
    });
  }

  Future<Map<String, dynamic>> jobDescriptionFor(String jobId) async {
    return _diohelper.apiCall(steps: () async {
      Response response = await _dio.get("${url.allJobs}/$jobId");
      if (response.statusCode == 200) {
        Data jobData = Data.fromJson(response.data["data"]);
        return {"status": "success", "singleJobDesc": jobData};
      }
    });
  }

  Future<Map<String, dynamic>> applyJob(String jobId) async {
    _prefs = await SharedPreferences.getInstance();
    String token = _prefs.getString("token");
    var params = {"jobId": jobId};
    print(params);
    return _diohelper.apiCall(steps: () async {
      _dio.options.headers = {"Authorization": token};
      Response response = await _dio.post(url.applyJob, data: params);
      return {"status": "success"};
    });
  }
}
