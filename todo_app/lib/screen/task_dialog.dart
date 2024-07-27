import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/task/task_bloc.dart';
import 'package:todo_app/bloc/task/task_event.dart';
import 'package:todo_app/models/task.dart';

class TaskDialog extends StatefulWidget {
  const TaskDialog({
    super.key,
    this.task,
  });
  final Task? task;
  @override
  State<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late bool _completed;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.task?.description ?? '');
    _completed = widget.task?.completed ?? false;
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
        TextButton(
          onPressed: () {
            if (widget.task == null) {
              context.read<TaskBloc>().add(TaskCreate(
                  title: _titleController.text.trim(),
                  description: _descriptionController.text.trim()));
            } else {
              context.read<TaskBloc>().add(TaskUpdate(
                  id: widget.task!.id,
                  title: _titleController.text.trim(),
                  description: _descriptionController.text.trim(),
                  completed: _completed));
            }

            Navigator.of(context).pop();
          },
          child: Text(widget.task == null ? 'Create' : 'Update'),
        ),
      ],
    );
  }
}
