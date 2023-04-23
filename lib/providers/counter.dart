import 'package:flutter_riverpod/flutter_riverpod.dart';

class CounterNotifier extends StateNotifier<int> {
  CounterNotifier(int initialValue) : super(initialValue);

  void increment() => state++;
}

final counterProvider = StateNotifierProvider(
  (ref) => CounterNotifier(0),
);
