part of 'task_bloc.dart';

abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskListEmpty extends TaskState {}

class TaskFailure extends TaskState {
  String msg;
  TaskFailure({required this.msg});
}

//Loading

class ListStateLoading extends TaskState {}

class CreateStateLoading extends TaskState {}

class UpdateStateLoading extends TaskState {}

class DeleteStateLoading extends TaskState {}

//sucess state
class TaskListFetchedSuccess extends TaskState {
  List<Task> taskList;
  TaskListFetchedSuccess({required this.taskList});
}

class TaskCreatedState extends TaskState {}

class TaskUpdatedState extends TaskState {}

class TaskDeletedState extends TaskState {}
