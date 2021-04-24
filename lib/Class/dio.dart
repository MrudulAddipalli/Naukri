import 'package:dio/dio.dart';
import "../Constansts/urls.dart" as url;
import 'dart:convert';
import 'dart:io';

import '../Models/Job.dart';

class DIO {
  //
  static Dio _dio = Dio(
    BaseOptions(
      baseUrl: url.baseURl,
    ),
  );

  static DIO _instance;
  DIO._() {}
  static DIO get getInstance => _instance ??= DIO._();
  static Dio get getDioInstance => _dio;

  Future<Map<String, dynamic>> apiCall({Function steps}) async {
    try {
      return await steps();
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
      return returnError(errors);
    } catch (errors) {
      return returnError(errors);
    }
  }

  Map<String, dynamic> returnError(var errors) {
    String responseBody = errors.response.toString();
    dynamic jsonObject = json.decode(responseBody);
    Map<String, dynamic> errorMap = {};
    if (jsonObject["errors"] != null) {
      for (int i = 0; i < jsonObject["errors"].length; i++) {
        errorMap.addAll(jsonObject["errors"][i]);
      }
    } else if (jsonObject["message"] != null) {
      errorMap.addAll({"generalerror": jsonObject["message"]});
    }
    print("singin/up error -$errorMap");
    return {
      "status": "failed",
      "errors": errorMap,
    };
  }
}
