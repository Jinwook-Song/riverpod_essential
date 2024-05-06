import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'main.dart';

part 'counter_provider.g.dart';

@riverpod
class Counter extends _$Counter {
  @override
  int build() {
    final preferences = ref.watch(sharedPreferencesProvider);
    final currentValue = preferences.getInt('counter') ?? 0;

    // 자기 자신의 state가 변할때마다 호출 된다.
    ref.listenSelf((previous, next) {
      print('previous: $previous, next: $next');
      if (next == 0) preferences.remove('counter');
      preferences.setInt('counter', next);
    });

    return currentValue;
  }

  void increment() {
    state++;
  }

  void clear() {
    state = 0;
  }
}
