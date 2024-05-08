// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_list_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TodoListStateImpl _$$TodoListStateImplFromJson(Map<String, dynamic> json) =>
    _$TodoListStateImpl(
      status: $enumDecode(_$TodoListStatusEnumMap, json['status']),
      todos: (json['todos'] as List<dynamic>)
          .map((e) => Todo.fromJson(e as Map<String, dynamic>))
          .toList(),
      error: json['error'] as String? ?? '',
    );

Map<String, dynamic> _$$TodoListStateImplToJson(_$TodoListStateImpl instance) =>
    <String, dynamic>{
      'status': _$TodoListStatusEnumMap[instance.status]!,
      'todos': instance.todos,
      'error': instance.error,
    };

const _$TodoListStatusEnumMap = {
  TodoListStatus.initial: 'initial',
  TodoListStatus.loading: 'loading',
  TodoListStatus.success: 'success',
  TodoListStatus.failure: 'failure',
};
