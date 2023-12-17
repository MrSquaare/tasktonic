import 'package:flutter_test/flutter_test.dart';
import 'package:tasktonic/models/task.dart';

void main() {
  group('Task model', () {
    test('Should create a Task instance', () {
      final task = Task(name: 'Test Task', dateStr: '2021-01-01');

      expect(task, isA<Task>());
    });

    test('Should have specified parameters as properties', () {
      final task = Task(
        name: 'Test Task',
        description: 'Test Description',
        status: TaskStatus.done,
        dateStr: '2021-01-01',
      );

      expect(task.name, 'Test Task');
      expect(task.description, 'Test Description');
      expect(task.status, TaskStatus.done);
      expect(task.dateStr, '2021-01-01');
      expect(task.date, DateTime(2021, 1, 1));
    });

    test('Should have todo status by default', () {
      final task = Task(name: 'Test Task', dateStr: '2021-01-01');

      expect(task.status, TaskStatus.todo);
    });

    test('Should switch from todo to done when toggle method is called', () {
      final task = Task(name: 'Test Task', dateStr: '2021-01-01');

      task.toggle();

      expect(task.status, TaskStatus.done);
    });

    test('Should switch from done to todo when toggle method is called', () {
      final task = Task(
        name: 'Test Task',
        dateStr: '2021-01-01',
        status: TaskStatus.done,
      );

      task.toggle();

      expect(task.status, TaskStatus.todo);
    });

    test('Should return a String representation when toString is called', () {
      final task = Task(
        name: 'Test Task',
        dateStr: '2021-01-01',
        description: 'Test Description',
      );

      expect(
        task.toString(),
        'Task{name: Test Task, description: Test Description, status: TaskStatus.todo, dateStr: 2021-01-01, reminderStr: null, rrule: null}',
      );
    });
  });
}
