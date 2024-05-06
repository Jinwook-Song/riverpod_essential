import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'counter_provider.dart';
import 'other_page.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scope: Sync-Async'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$counter',
              style: const TextStyle(fontSize: 52),
            ),
            const SizedBox(height: 20.0),
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const OtherPage();
                    },
                  ),
                );
              },
              child: const Text(
                'Other Page',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'increment',
            onPressed: () {
              ref.read(counterProvider.notifier).increment();
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'clear',
            onPressed: () {
              ref.read(counterProvider.notifier).clear();
            },
            child: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
