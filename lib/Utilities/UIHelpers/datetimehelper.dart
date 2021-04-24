import 'package:intl/intl.dart';

String timeAgo(String date) {
  DateTime dateTime = DateTime.parse(date);
  String daysago = DateTime.now().difference(dateTime).inDays.toString();
  String hoursago;
  String secondsago;
  if (daysago == "0") {
    hoursago = DateTime.now().difference(dateTime).inHours.toString();
    return "$hoursago Hours Ago";
  } else if (hoursago == "0") {
    secondsago = DateTime.now().difference(dateTime).inSeconds.toString();
    return "$secondsago Seconds Ago";
  } else {
    return "$daysago Days Ago";
  }
}

String customDay(DateTime date) {
  String fulldate = DateFormat.yMEd().format(date);
  return "${_dayname[fulldate.substring(0, 3)]}";
}

String customDate(DateTime date) {
  return (DateFormat('d MMM, yyyy').format(date));
}

String customTime(DateTime date) {
  return "${DateFormat.Hm().format(date)}";
}

final Map<String, String> _dayname = {
  "Mon": "Monday",
  "Tue": "Tuesday",
  "Wed": "Wed",
  "Thu": "Thursday",
  "Fri": "Friday",
  "Sat": "Saturday",
  "Sun": "Sunday"
};
