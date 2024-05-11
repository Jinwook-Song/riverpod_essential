import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod_sync/models/todo_model.dart';
import 'package:todo_riverpod_sync/pages/providers/todo_filter/todo_filter_provider.dart';
import 'package:todo_riverpod_sync/pages/providers/todo_item/todo_item_provider.dart';
import 'package:todo_riverpod_sync/pages/providers/todo_list/todo_list_provider.dart';
import 'package:todo_riverpod_sync/pages/providers/todo_list/todo_list_state.dart';
import 'package:todo_riverpod_sync/pages/providers/todo_search/todo_search_provider.dart';
import 'package:todo_riverpod_sync/pages/widgets/todo_item.dart';

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

  List<Todo> _filterTodos(List<Todo> allTodos) {
    final filter = ref.watch(todoFilterProvider);
    final search = ref.watch(todoSearchProvider);

    List<Todo> tempTodos;

    tempTodos = switch (filter) {
      Filter.active => allTodos.where((todo) => !todo.completed).toList(),
      Filter.completed => allTodos.where((todo) => todo.completed).toList(),
      Filter.all => allTodos,
    };

    if (search.isNotEmpty) {
      tempTodos = tempTodos
          .where(
              (todo) => todo.desc.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }

    return tempTodos;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(todoListProvider, (previous, next) {
      switch (next) {
        case TodoListStateFailure(error: String error):
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text(
                  'Error',
                  textAlign: TextAlign.center,
                ),
                content: Text(
                  error,
                  textAlign: TextAlign.center,
                ),
              );
            },
          );
        case _:
      }
    });

    final todoListState = ref.watch(todoListProvider);

    switch (todoListState) {
      case TodoListStateInitial():
        return const SizedBox.shrink();
      case TodoListStateLoading():
        return prevTodosWidge;
      // when guard
      // case TodoListStatus.failure when todoListState.todos.isEmpty:
      case TodoListStateFailure(error: var error)
          when prevTodosWidge is SizedBox:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                error,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: ref.read(todoListProvider.notifier).getTodos,
                child: const Text(
                  'Please Retry',
                  style: TextStyle(fontSize: 20),
                ),
              )
            ],
          ),
        );

      case TodoListStateFailure(error: _):
        return prevTodosWidge;
      case TodoListStateSuccess(todos: var allTodos):
        final filteredTodos = _filterTodos(allTodos);

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
