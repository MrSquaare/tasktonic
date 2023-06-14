import 'package:easy_localization/easy_localization.dart';

final dateStringFormat = DateFormat('yyyy-MM-dd');
final timeStringFormat = DateFormat('HH:mm');

String? dateTimeToDateString(DateTime? dateTime) {
  if (dateTime == null) return null;

  return dateStringFormat.format(dateTime);
}

DateTime? dateStringToDateTime(String? dateString) {
  if (dateString == null) return null;

  return dateStringFormat.parse(dateString);
}

String? dateTimeToTimeString(DateTime? dateTime) {
  if (dateTime == null) return null;

  return timeStringFormat.format(dateTime);
}

DateTime? timeStringToDateTime(String? timeString) {
  if (timeString == null) return null;

  return timeStringFormat.parse(timeString);
}
