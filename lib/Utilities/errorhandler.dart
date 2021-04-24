import 'dart:convert';

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
