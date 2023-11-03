import 'package:intl/intl.dart';

final dateStringFormat = DateFormat('yyyy-MM-dd');
final timeStringFormat = DateFormat('HH:mm');

class DateUtilities {
  static String formatDate(DateTime date) {
    return dateStringFormat.format(date);
  }

  static String formatTime(DateTime time) {
    return timeStringFormat.format(time);
  }

  static DateTime parseDate(String date) {
    return dateStringFormat.parse(date);
  }

  static DateTime parseTime(String time) {
    return timeStringFormat.parse(time);
  }
}
