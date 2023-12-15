part of 'task_bloc.dart';

abstract class TaskEvent {}

class FetchTaskList extends TaskEvent {
  FetchTaskList();
}

class DeleteAllTaskEvent extends TaskEvent {
  DeleteAllTaskEvent();
}

class CreateTaskEvent extends TaskEvent {
  Task task;

  CreateTaskEvent({required this.task});
}

class UpdateTaskEvent extends TaskEvent {
  Task task;

  UpdateTaskEvent({
    required this.task,
  });
}

class DeleteTaskEvent extends TaskEvent {
  Task task;

  DeleteTaskEvent({required this.task});
}
