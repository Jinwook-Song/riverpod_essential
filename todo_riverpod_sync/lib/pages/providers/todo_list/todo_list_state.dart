import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todo_riverpod_sync/models/todo_model.dart';

part 'todo_list_state.freezed.dart';
part 'todo_list_state.g.dart';

enum TodoListStatus {
  initial,
  loading,
  success,
  failure,
}

@freezed
class TodoListState with _$TodoListState {
  const factory TodoListState(
      {required TodoListStatus status,
      required List<Todo> todos,
      @Default('') String error}) = _TodoListState;

  factory TodoListState.fromJson(Map<String, dynamic> json) =>
      _$TodoListStateFromJson(json);

  factory TodoListState.initial() {
    return const TodoListState(
      status: TodoListStatus.initial,
      todos: [],
    );
  }
}
