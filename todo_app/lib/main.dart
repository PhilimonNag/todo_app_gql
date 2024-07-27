import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/task/task_bloc.dart';
import 'package:todo_app/graphql/graphql_config.dart';
import 'package:todo_app/repositories/task_repository.dart';
import 'package:todo_app/screen/todo_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => TaskRepository(GraphQLConfig.client),
      child: BlocProvider(
        create: (context) =>
            TaskBloc(taskRepository: context.read<TaskRepository>()),
        child: MaterialApp(
          title: 'Todo App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const TodoScreen(),
        ),
      ),
    );
  }
}
