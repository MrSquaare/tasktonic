import 'package:flutter_test/flutter_test.dart';
import 'package:tasktonic/utilities/task.dart';

void main() async {
  test('Should convert 00:00:00 int time to DateTime 1', () {
    const intTime = 0;
    final dateTime = DateTime.utc(1970, 1, 1, 0, 0, 0).toLocal();

    expect(convertUTCTimeToDateTime(intTime), dateTime);
  });

  test('Should convert 01:00:00 int time to DateTime', () {
    const intTime = 3600;
    final dateTime = DateTime.utc(1970, 1, 1, 1, 0, 0).toLocal();

    expect(convertUTCTimeToDateTime(intTime), dateTime);
  });

  test('Should convert 17:07:20 int time to DateTime', () {
    const intTime = 61640;
    final dateTime = DateTime.utc(1970, 1, 1, 17, 7, 20).toLocal();

    expect(convertUTCTimeToDateTime(intTime), dateTime);
  });

  test('Should convert 00:00:00 DateTime to int time', () {
    final dateTime = DateTime.utc(1970, 1, 1, 0, 0, 0);
    const intTime = 0;

    expect(convertDateTimeToUTCTime(dateTime), intTime);
  });

  test('Should convert 01:00:00 DateTime to int time', () {
    final dateTime = DateTime.utc(1970, 1, 1, 1, 0, 0);
    const intTime = 3600;

    expect(convertDateTimeToUTCTime(dateTime), intTime);
  });

  test('Should convert 17:07:20 DateTime to int time', () {
    final dateTime = DateTime.utc(1970, 1, 1, 17, 7, 20);
    const intTime = 61640;

    expect(convertDateTimeToUTCTime(dateTime), intTime);
  });

  test('Should convert 00:00:30 local DateTime to int time', () {
    final dateTime = DateTime(1970, 1, 1, 0, 0, 30);
    final intTime = (30 - dateTime.timeZoneOffset.inSeconds) % 86400;

    expect(convertDateTimeToUTCTime(dateTime), intTime);
  });

  test('Should convert 23:59:30 local DateTime to int time', () {
    final dateTime = DateTime(1970, 1, 1, 23, 59, 30);
    final intTime = (86370 - dateTime.timeZoneOffset.inSeconds) % 86400;

    expect(convertDateTimeToUTCTime(dateTime), intTime);
  });
}
