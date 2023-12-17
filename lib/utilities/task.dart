import '../models/task.dart';
import 'date.dart';

Iterable<Task> filterTasksByDay(Iterable<Task> tasks, DateTime day) {
  final startOfDay = DateTime(
    day.year,
    day.month,
    day.day,
  ).copyWith(isUtc: true);
  final startOfDayStr = DateUtilities.formatDate(startOfDay);
  final endOfDay = DateTime(
    day.year,
    day.month,
    day.day,
    23,
    59,
    59,
  ).copyWith(isUtc: true);

  return tasks.where((task) {
    final dateComparison = startOfDayStr.compareTo(task.dateStr);

    if (dateComparison < 0) return false;
    if (dateComparison == 0) return true;
    if (task.rrule == null) return false;

    final taskInstances = task.rrule!.getInstances(
      start: task.date.copyWith(isUtc: true),
      after: startOfDay,
      before: endOfDay,
      includeAfter: true,
      includeBefore: true,
    );

    return taskInstances.isNotEmpty;
  }).toList();
}
