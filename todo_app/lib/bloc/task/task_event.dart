import 'package:equatable/equatable.dart';

abstract class TaskEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class TaskLoadEvent extends TaskEvent {}

class TaskCreate extends TaskEvent {
  final String title;
  final String description;

  TaskCreate({required this.title, required this.description});

  @override
  List<Object> get props => [title, description];
}

class TaskUpdate extends TaskEvent {
  final String id;
  final String title;
  final String description;
  final bool completed;

  TaskUpdate({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
  });

  @override
  List<Object> get props => [id, title, description, completed];
}
