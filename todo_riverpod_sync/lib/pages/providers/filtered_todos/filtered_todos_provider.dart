import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_riverpod_sync/models/todo_model.dart';
import 'package:todo_riverpod_sync/pages/providers/todo_filter/todo_filter_provider.dart';
import 'package:todo_riverpod_sync/pages/providers/todo_list/todo_list_provider.dart';
import 'package:todo_riverpod_sync/pages/providers/todo_search/todo_search_provider.dart';

part 'filtered_todos_provider.g.dart';

@riverpod
List<Todo> filteredTodos(FilteredTodosRef ref) {
  final todoListState = ref.watch(todoListProvider);
  final filter = ref.watch(todoFilterProvider);
  final searchTerm = ref.watch(todoSearchProvider);

  List<Todo> tempTodos;
  tempTodos = switch (filter) {
    Filter.all => todoListState.todos,
    Filter.active =>
      todoListState.todos.where((todo) => !todo.completed).toList(),
    Filter.completed =>
      todoListState.todos.where((todo) => todo.completed).toList(),
  };

  if (searchTerm.isEmpty) return tempTodos;
  return tempTodos.where((todo) => todo.desc.contains(searchTerm)).toList();
}
