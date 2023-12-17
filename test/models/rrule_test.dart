import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';
import 'package:rrule/rrule.dart';
import 'package:tasktonic/models/rrule.dart';

class MockBinaryReader with Mock implements BinaryReader {
  @override
  String readString([int? byteCount, Converter<List<int>, String>? decoder]) {
    return super.noSuchMethod(
      Invocation.method(#readString, [byteCount, decoder]),
      returnValue: 'RRULE:FREQ=DAILY;INTERVAL=1',
    );
  }
}

class MockBinaryWriter with Mock implements BinaryWriter {
  @override
  void writeString(
    String? value, {
    bool? writeByteCount,
    Converter<String, List<int>>? encoder,
  }) {
    super.noSuchMethod(
      Invocation.method(#writeString, [
        value,
        {
          #writeByteCount: writeByteCount,
          #encoder: encoder,
        }
      ]),
      returnValue: null,
    );
  }
}

void main() {
  group('RecurrenceRuleAdapter', () {
    test('Should write as string and read as instance', () {
      final adapter = RecurrenceRuleAdapter();
      final rrule = RecurrenceRule.fromString('RRULE:FREQ=DAILY;INTERVAL=1');
      final writer = MockBinaryWriter();

      when(writer.writeString(any)).thenReturn(null);

      adapter.write(writer, rrule);

      verify(writer.writeString('RRULE:FREQ=DAILY;INTERVAL=1')).called(1);

      final reader = MockBinaryReader();

      when(reader.readString()).thenReturn('RRULE:FREQ=DAILY;INTERVAL=1');

      final readRrule = adapter.read(reader);

      expect(readRrule, rrule);
    });
  });
}
