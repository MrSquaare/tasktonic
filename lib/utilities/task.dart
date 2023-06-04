DateTime convertUTCTimeToDateTime(int utcTime) {
  return DateTime.fromMillisecondsSinceEpoch(
    utcTime * 1000,
    isUtc: true,
  ).toLocal();
}

int convertDateTimeToUTCTime(DateTime dateTime) {
  final utcDateTime = dateTime.toUtc();

  return utcDateTime.hour * 3600 + utcDateTime.minute * 60 + utcDateTime.second;
}
