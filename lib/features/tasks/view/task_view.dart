import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hive_tdo/data/models/request/task.dart';
import 'package:flutter_hive_tdo/features/tasks/bloc/task_bloc.dart';
import 'package:ftoast/ftoast.dart';
import 'package:intl/intl.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../../core/utils/colors.dart';
import '../../../core/utils/strings.dart';

class TaskView extends StatefulWidget {
  final String title;
  final String subTitle;
  final Task? task;
  const TaskView({
    super.key,
    required this.title,
    required this.subTitle,
    required this.task,
  });

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subTitleController = TextEditingController();

  late DateTime selectedDateTime;
  String title = "";
  String subTitle = "";

  final TaskBloc _taskBloc = TaskBloc();
  @override
  void initState() {
    title = widget.title;
    subTitle = widget.subTitle;
    _titleController.text = title;
    _subTitleController.text = subTitle;
    selectedDateTime = widget.task?.createdAtDate ?? DateTime.now();
    super.initState();
  }

  /// Show Selected Date As String Format
  String showDate(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateFormat.yMMMEd().format(DateTime.now()).toString();
      } else {
        return DateFormat.yMMMEd().format(date).toString();
      }
    } else {
      return DateFormat.yMMMEd().format(widget.task!.createdAtDate).toString();
    }
  }

  String showTime(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateFormat.Hm().format(DateTime.now()).toString();
      } else {
        return DateFormat.Hm().format(date).toString();
      }
    } else {
      return DateFormat.Hm().format(widget.task!.createdAtDate).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const CircleAvatar(
                radius: 8,
                child: Icon(Icons.arrow_back),
              ),
            ),
          ),
          title: const Text("My Todo",
              style: TextStyle(
                  color: MyColors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          centerTitle: true,
          actions: const [
            Icon(
              Icons.add,
              color: MyColors.primaryColor,
              size: 32,
            ),
            SizedBox(width: 16)
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: BlocProvider(
              create: (context) => _taskBloc,
              child: BlocListener<TaskBloc, TaskState>(
                listener: (context, state) async {
                  log(state.toString());
                  if (state is TaskFailure) {
                    PanaraInfoDialog.show(
                      context,
                      title: "Error",
                      message: state.msg,
                      buttonText: "Okay",
                      onTapDismiss: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      panaraDialogType: PanaraDialogType.error,
                    );
                  }
                  if (state is CreateStateLoading ||
                      state is UpdateStateLoading) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return Center(
                          child: Container(
                            width: 100.0,
                            height: 100.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: const Center(
                                child: CircularProgressIndicator()),
                          ),
                        );
                      },
                    );
                  }
                  if (state is TaskCreatedState) {
                    _subTitleController.clear();
                    _titleController.clear();
                    PanaraInfoDialog.show(
                      context,
                      title: "Sucess",
                      message: "Task created successfully",
                      buttonText: "Okay",
                      onTapDismiss: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      panaraDialogType: PanaraDialogType.success,
                    );
                  }
                  if (state is TaskUpdatedState) {
                    _subTitleController.clear();
                    _titleController.clear();
                    PanaraInfoDialog.show(
                      context,
                      title: "Sucess",
                      message: "Task modified successfully",
                      buttonText: "Okay",
                      onTapDismiss: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      panaraDialogType: PanaraDialogType.success,
                    );
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    //Todo field
                    ListTile(
                      title: TextFormField(
                        controller: _titleController,
                        maxLines: 5,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        onFieldSubmitted: (value) {
                          title = value;
                        },
                        onChanged: (value) {
                          title = value;
                        },
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// Note TextField
                    ListTile(
                      title: TextFormField(
                        controller: _subTitleController,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          prefixIcon: const Icon(Icons.bookmark_border,
                              color: Colors.grey),
                          border: InputBorder.none,
                          counter: Container(),
                          hintText: MyString.addNote,
                        ),
                        onFieldSubmitted: (value) {
                          subTitle = value;
                        },
                        onChanged: (value) {
                          subTitle = value;
                        },
                      ),
                    ),

                    /// Time Picker
                    GestureDetector(
                      onTap: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            log(selectedDateTime.toString());
                            selectedDateTime = selectedDateTime.copyWith(
                                hour: picked.hour, minute: picked.minute);
                          });
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                              Border.all(color: Colors.grey.shade300, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(MyString.timeString,
                                  style: textTheme.titleLarge),
                            ),
                            Expanded(child: Container()),
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              width: 80,
                              height: 35,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade100),
                              child: Center(
                                child: Text(
                                  showTime(selectedDateTime),
                                  style: textTheme.titleMedium,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    /// Date Picker
                    GestureDetector(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null) {
                          setState(() {
                            log(selectedDateTime.toString());
                            selectedDateTime = selectedDateTime.copyWith(
                                day: picked.day,
                                month: picked.month,
                                year: picked.year);
                          });
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                              Border.all(color: Colors.grey.shade300, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(MyString.dateString,
                                  style: textTheme.titleLarge),
                            ),
                            Expanded(child: Container()),
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              width: 140,
                              height: 35,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade100),
                              child: Center(
                                child: Text(
                                  showDate(selectedDateTime),
                                  style: textTheme.titleMedium,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (_titleController.text.isEmpty) {
              FToast.toast(
                context,
                msg: MyString.oopsMsg,
                subMsg: "Todo Field can't be empty!",
                corner: 20.0,
                duration: 2000,
                padding: const EdgeInsets.all(20),
              );
            } else if (_subTitleController.text.isEmpty) {
              FToast.toast(
                context,
                msg: MyString.oopsMsg,
                subMsg: "Please add a note message!",
                corner: 20.0,
                duration: 2000,
                padding: const EdgeInsets.all(20),
              );
            } else if (widget.task != null) {
              _taskBloc.add(UpdateTaskEvent(
                  task: widget.task!.copyWith(
                      title: _titleController.text,
                      subtitle: _subTitleController.text,
                      createdAtDate: selectedDateTime)));
            } else {
              _taskBloc.add(
                CreateTaskEvent(
                  task: Task.create(
                    title: _titleController.text,
                    subtitle: _subTitleController.text,
                    createdAtDate: selectedDateTime,
                  ),
                ),
              );
            }
          },
          backgroundColor: MyColors.primaryColor,
          foregroundColor: MyColors.white,
          label: const Text("Add Task"),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }
}
