import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:todo_app/task_dialog.dart';
import 'graphql/queries.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  VoidCallback? _refetch;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
      ),
      body: Query(
        options: QueryOptions(
          document: gql(getTasksQuery),
        ),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (result.hasException) {
            return Center(
              child: Text(result.exception.toString()),
            );
          }

          if (_refetch == null && refetch != null) {
            Future.microtask(() => setState(() {
                  _refetch = refetch;
                }));
          }

          List tasks = result.data!['tasks'];

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];

              return ListTile(
                title: Text(task['title']),
                subtitle: Text(task['description']),
                trailing: Checkbox(
                  value: task['completed'],
                  onChanged: (bool? value) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return TaskDialog(task: task, refetch: _refetch);
                      },
                    );
                  },
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return TaskDialog(task: task, refetch: _refetch);
                    },
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return TaskDialog(refetch: _refetch);
            },
          );
        },
      ),
    );
  }
}
