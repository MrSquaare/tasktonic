import 'package:flutter_test/flutter_test.dart';
import 'package:tasktonic/models/task.dart';

void main() {
  test('Should create a Task instance', () {
    final task = Task(name: 'Test Task');

    expect(task, isA<Task>());
  });

  test('Should have specified parameters as properties', () {
    final task = Task(
      name: 'Test Task',
      description: 'Test Description',
      status: TaskStatus.done,
    );

    expect(task.name, 'Test Task');
    expect(task.description, 'Test Description');
    expect(task.status, TaskStatus.done);
  });

  test('Should have todo status by default', () {
    final task = Task(name: 'Test Task');

    expect(task.status, TaskStatus.todo);
  });

  test('Should switch from todo to done when toggle method is called', () {
    final task = Task(name: 'Test Task');

    task.toggle();

    expect(task.status, TaskStatus.done);
  });

  test('Should switch from done to todo when toggle method is called', () {
    final task = Task(name: 'Test Task', status: TaskStatus.done);

    task.toggle();

    expect(task.status, TaskStatus.todo);
  });

  test('Should return a String representation when toString is called', () {
    final task = Task(name: 'Test Task', description: 'Test Description');

    expect(
      task.toString(),
      'Task{name: Test Task, description: Test Description, status: TaskStatus.todo, date: null, reminder: null}',
    );
  });
}
