import 'package:hive/hive.dart';
import 'package:rrule/rrule.dart';

class RecurrenceRuleAdapter extends TypeAdapter<RecurrenceRule> {
  @override
  final typeId = 2;

  @override
  RecurrenceRule read(BinaryReader reader) {
    final rruleStr = reader.readString();

    return RecurrenceRule.fromString(rruleStr);
  }

  @override
  void write(BinaryWriter writer, RecurrenceRule obj) {
    writer.writeString(obj.toString());
  }
}
