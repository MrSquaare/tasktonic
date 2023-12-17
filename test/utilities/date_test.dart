import 'package:flutter_test/flutter_test.dart';
import 'package:tasktonic/utilities/date.dart';

void main() {
  group('DateUtilities', () {
    group('formatDate', () {
      test('Should returns formatted date string', () {
        final dateTime = DateTime(2022, 12, 31);
        const dateString = '2022-12-31';

        expect(DateUtilities.formatDate(dateTime), dateString);
      });
    });

    group('formatTime', () {
      test('Should returns formatted time string', () {
        final dateTime = DateTime(2022, 12, 31, 23, 59);
        const timeString = '23:59';

        expect(DateUtilities.formatTime(dateTime), timeString);
      });
    });

    group('parseDate', () {
      test('Should returns date time', () {
        const dateString = '2022-12-31';
        final dateTime = DateTime(2022, 12, 31);

        expect(DateUtilities.parseDate(dateString), dateTime);
      });
    });

    group('parseTime', () {
      test('Should returns date time', () {
        const timeString = '23:59';
        final dateTime = DateTime(1970, 1, 1, 23, 59);

        expect(DateUtilities.parseTime(timeString), dateTime);
      });
    });
  });
}
