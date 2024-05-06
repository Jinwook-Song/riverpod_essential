import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'counter_provider.g.dart';

@Riverpod(keepAlive: true, dependencies: [])
class Counter extends _$Counter {
  @override
  int build() {
    return 0;
  }

  void increment() => state++;
}

/// Counter Provider에서 초기값만 다르게 세팅
class Counter100 extends Counter {
  @override
  int build() {
    return 100;
  }
}
