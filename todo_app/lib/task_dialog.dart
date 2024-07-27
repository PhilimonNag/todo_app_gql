import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:todo_app/graphql/mutations.dart';

class TaskDialog extends StatefulWidget {
  final dynamic task;
  final VoidCallback? refetch;

  TaskDialog({this.task, this.refetch});

  @override
  _TaskDialogState createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late bool _completed;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?['title'] ?? '');
    _descriptionController =
        TextEditingController(text: widget.task?['description'] ?? '');
    _completed = widget.task?['completed'] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.task == null ? 'Create Task' : 'Update Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          if (widget.task != null)
            CheckboxListTile(
              title: const Text('Completed'),
              value: _completed,
              onChanged: (bool? value) {
                setState(() {
                  _completed = value!;
                });
              },
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        Mutation(
          options: MutationOptions(
            document: widget.task == null
                ? gql(createTaskMutation)
                : gql(updateTaskMutation),
            onCompleted: (dynamic resultData) {
              if (widget.refetch != null) {
                widget.refetch!();
              }
            },
          ),
          builder: (RunMutation runMutation, QueryResult? result) {
            return TextButton(
              onPressed: () {
                if (widget.task == null) {
                  runMutation({
                    'title': _titleController.text,
                    'description': _descriptionController.text,
                  });
                } else {
                  runMutation({
                    'id': widget.task['id'],
                    'title': _titleController.text,
                    'description': _descriptionController.text,
                    'completed': _completed,
                  });
                }
                Navigator.of(context).pop();
              },
              child: Text(widget.task == null ? 'Create' : 'Update'),
            );
          },
        ),
      ],
    );
  }
}
