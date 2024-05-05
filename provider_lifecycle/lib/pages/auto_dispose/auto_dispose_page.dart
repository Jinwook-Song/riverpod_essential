import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

class AutoDisposePage extends ConsumerWidget {
  const AutoDisposePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // widget rebuild 될때마다 listenr가 removed 되었다가 added 된다.
    // 앱 성능을 위해 Consumer 위젯을 통해 rebuild 되는 범위를 조정하는것이 필요
    ref.listen<int>(
      autoDisposeCounterProvider,
      (previous, next) {
        if (next % 3 == 0) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(content: Text('counter: $next'));
            },
          );
        }
      },
    );
    // final counter = ref.watch(autoDisposeCounterProvider);
    // final anotherCounter = ref.watch(anotherCounterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AutoDispose'),
      ),
      body: Center(
        child: Consumer(
          builder: (context, ref, child) {
            final counter = ref.watch(autoDisposeCounterProvider);
            final anotherCounter = ref.watch(anotherCounterProvider);
            return Text('$counter : $anotherCounter');
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: '1',
            onPressed: () {
              ref.read(autoDisposeCounterProvider.notifier).increment();
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            heroTag: '2',
            onPressed: () {
              ref.read(anotherCounterProvider.notifier).increment();
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
