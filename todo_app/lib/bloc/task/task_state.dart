import 'package:equatable/equatable.dart';
import 'package:todo_app/models/task.dart';

abstract class TaskState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TaskStateInitial extends TaskState {}

class TaskStateLoading extends TaskState {}

class TaskStateSuccess extends TaskState {
  final List<Task> tasks;
  TaskStateSuccess({required this.tasks});
  @override
  List<Object> get props => [tasks];
}

class TaskStateError extends TaskState {
  final String message;
  TaskStateError(this.message);
  @override
  List<Object> get props => [message];
}
