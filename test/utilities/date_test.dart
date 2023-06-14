import 'package:flutter_test/flutter_test.dart';
import 'package:tasktonic/utilities/date.dart';

void main() {
  group('dateTimeToDateString', () {
    test('Should returns null when given null', () {
      expect(dateTimeToDateString(null), null);
    });

    test('Should returns formatted date string when given a valid date time',
        () {
      final dateTime = DateTime(2022, 12, 31);
      const dateString = '2022-12-31';

      expect(dateTimeToDateString(dateTime), dateString);
    });
  });

  group('dateStringToDateTime', () {
    test('Should returns null when given null', () {
      expect(dateStringToDateTime(null), null);
    });

    test('Should returns date time when given a valid date string', () {
      const dateString = '2022-12-31';
      final dateTime = DateTime(2022, 12, 31);

      expect(dateStringToDateTime(dateString), dateTime);
    });
  });

  group('dateTimeToTimeString', () {
    test('Should returns null when given null', () {
      expect(dateTimeToTimeString(null), null);
    });

    test('Should returns formatted time string when given a valid date time',
        () {
      final dateTime = DateTime(2022, 12, 31, 23, 59);
      const timeString = '23:59';

      expect(dateTimeToTimeString(dateTime), timeString);
    });
  });

  group('timeStringToDateTime', () {
    test('Should returns null when given null', () {
      expect(timeStringToDateTime(null), null);
    });

    test('Should returns date time when given a valid time string', () {
      const timeString = '23:59';
      final dateTime = DateTime(1970, 1, 1, 23, 59);

      expect(timeStringToDateTime(timeString), dateTime);
    });
  });
}
