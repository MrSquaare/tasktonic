import 'package:hive/hive.dart';

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
  String name;
  @HiveField(1)
  String? description;
  @HiveField(2, defaultValue: TaskStatus.todo)
  TaskStatus status;
  @HiveField(3)
  DateTime? date;
  @HiveField(4)
  DateTime? reminder;

  Task({
    required this.name,
    this.description,
    this.status = TaskStatus.todo,
    this.date,
    this.reminder,
  });

  toggle() {
    status = status == TaskStatus.todo ? TaskStatus.done : TaskStatus.todo;
  }

  @override
  String toString() {
    return 'Task{name: $name, description: $description, status: $status, date: $date, reminder: $reminder}';
  }
}
