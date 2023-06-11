import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:styled_widget/styled_widget.dart';

import '../providers/task.dart';
import '../widgets/task/list.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    context.locale; // force rebuild when locale changes

    final tasks = ref.watch(taskProvider);

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('home.title'.tr()),
      ),
      body: tasks.when(
        data: (data) {
          if (data.isEmpty) {
            return Text('home.no_task'.tr()).center();
          }

          return TaskList(
            tasks: data,
            onToggle: (index, task) {
              ref.read(taskProvider.notifier).toggleTask(index, task);
            },
            onNavigate: (index, task) {
              context.push('/task/$index/details');
            },
          );
        },
        loading: () => const CircularProgressIndicator().center(),
        error: (error, _) => Text('home.error'.tr()).center(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/task/add'),
        tooltip: 'home.add'.tr(),
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
