import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:todo_riverpod_sync/pages/widgets/filter_todo.dart';
import 'package:todo_riverpod_sync/pages/widgets/new_todo.dart';
import 'package:todo_riverpod_sync/pages/widgets/search_todo.dart';
import 'package:todo_riverpod_sync/pages/widgets/show_todos.dart';
import 'package:todo_riverpod_sync/pages/widgets/todo_header.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: LoaderOverlay(
        useDefaultLoading: false,
        overlayWidgetBuilder: (_) {
          return const Center(
            child: SpinKitFadingCircle(
              color: Colors.grey,
            ),
          );
        },
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TodoHeader(),
              NewTodo(),
              SizedBox(height: 20),
              SearchTodo(),
              SizedBox(height: 10),
              FilterTodo(),
              SizedBox(height: 10),
              Expanded(child: ShowTodos()),
            ],
          ),
        ),
      )),
    );
  }
}
