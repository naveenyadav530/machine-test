import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_hive_tdo/core/utils/strings.dart';
import 'package:flutter_hive_tdo/data/models/request/task.dart';
import 'package:hive/hive.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TaskBloc() : super(TaskInitial()) {
    on<FetchTaskList>(_fetchTask);
    on<CreateTaskEvent>(_createTask);
    on<UpdateTaskEvent>(_updateTask);
    on<DeleteTaskEvent>(_deleteTask);
    on<DeleteAllTaskEvent>(_deleteAll);
  }
  FutureOr<void> _deleteAll(
      DeleteAllTaskEvent event, Emitter<TaskState> emit) async {
    emit(DeleteStateLoading());
    QuerySnapshot querySnapshot = await firestore.collection('tasks').get();
    for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
      await docSnapshot.reference.delete();
    }

    var box = await Hive.openBox<Task>(MyString.taskBox);
    box.clear();
    emit(TaskListEmpty());
  }

  //to delete the task
  FutureOr<void> _deleteTask(
      DeleteTaskEvent event, Emitter<TaskState> emit) async {
    emit(DeleteStateLoading());
    await firestore.collection('tasks').doc(event.task.id).delete();
    await event.task.delete();
    add(FetchTaskList());
  }

//to update the task
  FutureOr<void> _updateTask(
      UpdateTaskEvent event, Emitter<TaskState> emit) async {
    emit(UpdateStateLoading());

    try {
      final connection = await (Connectivity().checkConnectivity());
      if (connection == ConnectivityResult.mobile ||
          connection == ConnectivityResult.wifi) {
        await firestore
            .collection('tasks')
            .doc(event.task.id)
            .update(event.task.toMap());
      }
      try {
        await event.task.save();
      } catch (e) {
        log(e.toString());
      }

      emit(TaskUpdatedState());
    } catch (e) {
      emit(TaskFailure(msg: "Something went wrong!"));
    }
  }

  //Create Task
  FutureOr<void> _createTask(
      CreateTaskEvent event, Emitter<TaskState> emit) async {
    emit(CreateStateLoading());

    final connection = await (Connectivity().checkConnectivity());

    try {
      if (connection == ConnectivityResult.mobile ||
          connection == ConnectivityResult.wifi) {
        await firestore
            .collection('tasks')
            .doc(event.task.id)
            .set(event.task.toMap());
      }

      final Box<Task> box = Hive.box<Task>(MyString.taskBox);
      await box.put(event.task.id, event.task);

      emit(TaskCreatedState());
    } catch (e) {
      emit(TaskFailure(msg: "Something went wrong!"));
    }
  }

  //Fetch all the task list
  FutureOr<void> _fetchTask(
      FetchTaskList event, Emitter<TaskState> emit) async {
    emit(ListStateLoading());
    final connection = await (Connectivity().checkConnectivity());
    final Box<Task> box = Hive.box<Task>(MyString.taskBox);
    List<Task> task = [];

    if (connection == ConnectivityResult.mobile ||
        connection == ConnectivityResult.wifi) {
      QuerySnapshot querySnapshot = await firestore.collection('tasks').get();
      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
          var data = docSnapshot.data() as Map<String, dynamic>;
          task.add(Task.fromMap(data));
        }
      }
    }
    if (task.isEmpty) {
      var tasks = box.values.toList();
      tasks.sort(((a, b) => b.createdAtDate.compareTo(a.createdAtDate)));
      tasks.isEmpty
          ? emit(TaskListEmpty())
          : emit(TaskListFetchedSuccess(taskList: task));
    } else {
      task.sort(((a, b) => b.createdAtDate.compareTo(a.createdAtDate)));
      emit(TaskListFetchedSuccess(taskList: task));
    }
  }
}
