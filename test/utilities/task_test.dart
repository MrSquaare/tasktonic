import 'package:flutter_test/flutter_test.dart';
import 'package:rrule/rrule.dart';
import 'package:tasktonic/models/task.dart';
import 'package:tasktonic/utilities/task.dart';

void main() {
  group('filterTasksByDay', () {
    test('Should return an empty list if no tasks are provided', () {
      final tasks = <Task>[];
      final day = DateTime(2021, 1, 1);

      final result = filterTasksByDay(tasks, day);

      expect(result, isEmpty);
    });

    test('Should return tasks that match the specified day', () {
      final tasks = [
        Task(name: 'Task 1', dateStr: '2021-01-01'),
        Task(name: 'Task 2', dateStr: '2021-01-02'),
        Task(name: 'Task 3', dateStr: '2021-01-01'),
      ];
      final day = DateTime(2021, 1, 1);

      final result = filterTasksByDay(tasks, day);

      expect(result.length, 2);
      expect(result.elementAt(0).name, 'Task 1');
      expect(result.elementAt(1).name, 'Task 3');
    });

    test(
        'Should return tasks that match the specified day using recurrence rule',
        () {
      final tasks = [
        Task(
          name: 'Task 1',
          dateStr: '2021-01-06',
          rrule: RecurrenceRule(
            frequency: Frequency.daily,
            interval: 2,
          ),
        ),
        Task(name: 'Task 2', dateStr: '2021-01-02'),
        Task(
          name: 'Task 3',
          dateStr: '2021-01-01',
          rrule: RecurrenceRule(
            frequency: Frequency.weekly,
            interval: 1,
          ),
        ),
      ];
      final day = DateTime(2021, 1, 8);

      final result = filterTasksByDay(tasks, day);

      expect(result.length, 2);
      expect(result.elementAt(0).name, 'Task 1');
      expect(result.elementAt(1).name, 'Task 3');
    });

    test('Should return an empty list if no tasks match the specified day', () {
      final tasks = [
        Task(name: 'Task 1', dateStr: '2021-01-02'),
        Task(name: 'Task 2', dateStr: '2021-01-03'),
      ];
      final day = DateTime(2021, 1, 1);

      final result = filterTasksByDay(tasks, day);

      expect(result, isEmpty);
    });
  });
}
