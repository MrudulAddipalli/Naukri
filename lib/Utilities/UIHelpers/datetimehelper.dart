import 'package:intl/intl.dart';

String timeAgo(String date) {
  DateTime dateTime = DateTime.parse(date);
  int daysago = DateTime.now().difference(dateTime).inDays;
  int hoursago = DateTime.now().difference(dateTime).inHours;
  int minutesago = DateTime.now().difference(dateTime).inMinutes;
  String message = "";
  if (daysago == 0 && hoursago <= 0) {
    message = "$minutesago Minutes Ago";
  } else if (daysago == 0) {
    message = "$hoursago Hours Ago";
  } else {
    message = "$daysago Days Ago";
  }
  return message;
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
