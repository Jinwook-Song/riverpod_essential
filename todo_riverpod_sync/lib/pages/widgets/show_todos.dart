import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod_sync/pages/providers/todo_item/todo_item_provider.dart';
import 'package:todo_riverpod_sync/pages/providers/todo_list/todo_list_provider.dart';
import 'package:todo_riverpod_sync/pages/providers/todo_list/todo_list_state.dart';
import 'package:todo_riverpod_sync/pages/widgets/todo_item.dart';

import '../providers/filtered_todos/filtered_todos_provider.dart';

class ShowTodos extends ConsumerStatefulWidget {
  const ShowTodos({super.key});

  @override
  ConsumerState<ShowTodos> createState() => _ShowTodosState();
}

class _ShowTodosState extends ConsumerState<ShowTodos> {
  Widget prevTodosWidge = const SizedBox.shrink();

  @override
  void initState() {
    super.initState();

    /// 현재 frame이 완성된 뒤 요청을 해야함
    /// 1. WidgetsBinding.instance.addPostFrameCallback
    /// 2. Future.microtask
    /// 3. Future.delayed
    /// 위 세가지 방법을 사용할 수 있다.

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref.read(todoListProvider.notifier).getTodos();
    // });
    // Future.delayed(Duration.zero, () {
    //   ref.read(todoListProvider.notifier).getTodos();
    // });
    Future.microtask(() {
      ref.read(todoListProvider.notifier).getTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(todoListProvider, (previous, next) {
      if (next.status == TodoListStatus.failure) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                'Error',
                textAlign: TextAlign.center,
              ),
              content: Text(
                next.error,
                textAlign: TextAlign.center,
              ),
            );
          },
        );
      }
    });

    final todoListState = ref.watch(todoListProvider);

    switch (todoListState.status) {
      case TodoListStatus.initial:
        return const SizedBox.shrink();
      case TodoListStatus.loading:
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      // when guard
      // case TodoListStatus.failure when todoListState.todos.isEmpty:
      case TodoListStatus.failure when prevTodosWidge is SizedBox:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                todoListState.error,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: ref.read(todoListProvider.notifier).getTodos,
                child: const Text(
                  'Pleae Retry',
                  style: TextStyle(fontSize: 20),
                ),
              )
            ],
          ),
        );

      case TodoListStatus.failure:
      case TodoListStatus.success:
        final filteredTodos = ref.watch(filteredTodosProvider);

        prevTodosWidge = ListView.separated(
          itemCount: filteredTodos.length,
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(color: Colors.grey);
          },
          itemBuilder: (BuildContext context, int index) {
            final todo = filteredTodos[index];
            return ProviderScope(
                overrides: [todoItemProvider.overrideWithValue(todo)],
                child: const TodoItem());
          },
        );
        return prevTodosWidge;
    }
  }
}
