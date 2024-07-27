import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/task/task_bloc.dart';
import 'package:todo_app/bloc/task/task_event.dart';
import 'package:todo_app/bloc/task/task_state.dart';
import 'package:todo_app/screen/task_dialog.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  @override
  void initState() {
    context.read<TaskBloc>().add(TaskLoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
      ),
      body: BlocBuilder<TaskBloc, TaskState>(builder: (context, state) {
        print("state is ${state.toString()}");
        if (state is TaskStateLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is TaskStateError) {
          return Center(
            child: Text(state.message),
          );
        }
        if (state is TaskStateSuccess) {
          return ListView.builder(
            itemCount: state.tasks.length,
            itemBuilder: (context, index) {
              final task = state.tasks[index];

              return ListTile(
                title: Text(task.title),
                subtitle: Text(task.description),
                trailing: Checkbox(
                  value: task.completed,
                  onChanged: (bool? value) {
                    context.read<TaskBloc>().add(TaskUpdate(
                        id: task.id,
                        title: task.title,
                        description: task.description,
                        completed: value ?? task.completed));
                  },
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return TaskDialog(
                        task: task,
                      );
                    },
                  );
                },
              );
            },
          );
        }
        return Container();
      }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return const TaskDialog(task: null);
            },
          );
        },
      ),
    );
  }
}
