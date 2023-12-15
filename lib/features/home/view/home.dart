// ignore_for_file: must_be_immutable

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hive_tdo/data/models/request/task.dart';
import 'package:flutter_hive_tdo/features/tasks/bloc/task_bloc.dart';
import 'package:intl/intl.dart';

import 'package:lottie/lottie.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../../core/utils/colors.dart';
import '../../tasks/view/task_view.dart';
import '../../../core/utils/strings.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final TaskBloc _taskBloc = TaskBloc();
  @override
  void initState() {
    _taskBloc.add(FetchTaskList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Task> tasks = [];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: CircleAvatar(
            radius: 8,
            child: Image.asset('assets/img/1.png'),
          ),
        ),
        title: const Text(
          "My Todo",
          style: TextStyle(
              color: MyColors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              PanaraConfirmDialog.show(
                context,
                title: MyString.areYouSure,
                message:
                    "Do You really want to delete all tasks? You will no be able to undo this action!",
                confirmButtonText: "Yes",
                cancelButtonText: "No",
                onTapCancel: () {
                  Navigator.pop(context);
                },
                onTapConfirm: () {
                  Navigator.pop(context);
                  _taskBloc.add(DeleteAllTaskEvent());
                },
                panaraDialogType: PanaraDialogType.error,
                barrierDismissible: false,
              );
            },
            child: const Icon(
              Icons.delete_forever,
              color: MyColors.red,
            ),
          ),
          const SizedBox(width: 8)
        ],
      ),
      body: SafeArea(
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: BlocProvider(
              create: (context) => _taskBloc,
              child: BlocBuilder<TaskBloc, TaskState>(
                bloc: _taskBloc,
                builder: (context, state) {
                  if (state is TaskFailure || state is TaskListEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FadeIn(
                            child: SizedBox(
                              width: 200,
                              height: 200,
                              child: Lottie.asset(
                                'assets/lottie/1.json',
                                animate: tasks.isNotEmpty ? false : true,
                              ),
                            ),
                          ),
                          FadeInUp(
                            from: 30,
                            child: const Text(MyString.doneAllTask),
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is TaskListFetchedSuccess) {
                    List<Task> tasks = state.taskList;
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: tasks.length,
                      itemBuilder: (BuildContext context, int index) {
                        var task = tasks[index];

                        return Dismissible(
                          direction: DismissDirection.horizontal,
                          background: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.delete_outline,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 8),
                              Text(MyString.deletedTask,
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ))
                            ],
                          ),
                          onDismissed: (direction) {
                            _taskBloc.add(DeleteTaskEvent(task: task));
                          },
                          key: Key(task.id),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (ctx) => TaskView(
                                    title: task.title,
                                    subTitle: task.subtitle,
                                    task: task,
                                  ),
                                ),
                              ).then((value) {
                                _taskBloc.add(FetchTaskList());
                                print("Log in");
                              });
                            },

                            /// Main Card
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 600),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                  color: task.isCompleted
                                      ? const Color.fromARGB(154, 119, 144, 229)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(.1),
                                        offset: const Offset(0, 4),
                                        blurRadius: 10)
                                  ]),
                              child: ListTile(

                                  /// Check icon
                                  leading: GestureDetector(
                                    onTap: () {
                                      task.isCompleted = !task.isCompleted;
                                      task.save();
                                      setState(() {});
                                    },
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 600),
                                      decoration: BoxDecoration(
                                          color: task.isCompleted
                                              ? MyColors.primaryColor
                                              : Colors.white,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.grey, width: .8)),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),

                                  /// title of Task
                                  title: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 5, top: 3),
                                    child: Text(
                                      task.title,
                                      style: TextStyle(
                                          color: task.isCompleted
                                              ? MyColors.primaryColor
                                              : Colors.black,
                                          fontWeight: FontWeight.w500,
                                          decoration: task.isCompleted
                                              ? TextDecoration.lineThrough
                                              : null),
                                    ),
                                  ),

                                  /// Description of task
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        task.subtitle,
                                        style: TextStyle(
                                          color: task.isCompleted
                                              ? MyColors.primaryColor
                                              : const Color.fromARGB(
                                                  255, 164, 164, 164),
                                          fontWeight: FontWeight.w300,
                                          decoration: task.isCompleted
                                              ? TextDecoration.lineThrough
                                              : null,
                                        ),
                                      ),

                                      /// Date & Time of Task
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 10,
                                            top: 10,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                DateFormat.Hm()
                                                    .format(task.createdAtDate)
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: task.isCompleted
                                                        ? Colors.white
                                                        : Colors.grey),
                                              ),
                                              Text(
                                                DateFormat.yMMMEd()
                                                    .format(task.createdAtDate),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: task.isCompleted
                                                        ? Colors.white
                                                        : Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  if (state is ListStateLoading || state is TaskInitial) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return const Center(child: Text("Unknown Error Accured"));
                  }
                },
              ),
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
                CupertinoPageRoute(
                  builder: (context) => const TaskView(
                    subTitle: "",
                    title: "",
                    task: null,
                  ),
                ),
              )
              .then((value) => _taskBloc.add(FetchTaskList()));
        },
        backgroundColor: MyColors.primaryColor,
        foregroundColor: MyColors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
