import 'package:hive/hive.dart';
import 'package:rrule/rrule.dart';
import 'package:uuid/uuid.dart';

import '../utilities/date.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
enum TaskStatus {
  @HiveField(0)
  todo,
  @HiveField(1)
  done,
}

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  late String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String? description;
  @HiveField(3, defaultValue: TaskStatus.todo)
  TaskStatus status;
  @HiveField(4)
  String dateStr; // UTC Date, format: yyyy-MM-dd
  late DateTime date;
  @HiveField(5)
  String? reminderStr; // UTC Time, format: HH:mm
  late DateTime? reminder;
  @HiveField(6)
  RecurrenceRule? rrule;

  Task({
    required this.name,
    this.description,
    this.status = TaskStatus.todo,
    required this.dateStr,
    this.reminderStr,
    this.rrule,
  }) {
    id = const Uuid().v4();

    date = DateUtilities.parseDate(dateStr);
    reminder = null;

    if (reminderStr != null) {
      reminder = DateUtilities.parseTime(reminderStr!);
    }
  }

  factory Task.fromDates({
    required String name,
    String? description,
    TaskStatus status = TaskStatus.todo,
    required DateTime date,
    DateTime? reminder,
    RecurrenceRule? rrule,
  }) {
    return Task(
      name: name,
      description: description,
      status: status,
      dateStr: DateUtilities.formatDate(date),
      reminderStr: reminder != null ? DateUtilities.formatTime(reminder) : null,
      rrule: rrule,
    );
  }

  toggle() {
    status = status == TaskStatus.todo ? TaskStatus.done : TaskStatus.todo;
  }

  @override
  String toString() {
    return 'Task{name: $name, description: $description, status: $status, dateStr: $dateStr, reminderStr: $reminderStr, rrule: $rrule}';
  }
}
