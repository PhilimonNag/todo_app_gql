import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/task/task_event.dart';
import 'package:todo_app/bloc/task/task_state.dart';
import 'package:todo_app/repositories/task_repository.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;
  TaskBloc({required this.taskRepository}) : super(TaskStateInitial()) {
    on<TaskLoadEvent>((event, emit) async {
      try {
        emit(TaskStateLoading());
        final tasks = await taskRepository.getTasks();
        emit(TaskStateSuccess(tasks: tasks));
      } catch (e) {
        emit(TaskStateError(e.toString()));
      }
    });
    on<TaskCreate>(
      (event, emit) async {
        try {
          await taskRepository.createTask(event.title, event.description);
          add(TaskLoadEvent());
        } catch (e) {
          emit(TaskStateError(e.toString()));
        }
      },
    );
    on<TaskUpdate>(
      (event, emit) async {
        try {
          await taskRepository.updateTask(
            event.id,
            event.title,
            event.description,
            event.completed,
          );
          add(TaskLoadEvent());
        } catch (e) {
          emit(TaskStateError(e.toString()));
        }
      },
    );
  }
}
