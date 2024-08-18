import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/tabs/settings/settings_provider.dart';
import 'package:todo/tabs/tasks/edit_task_screen.dart';
import 'package:todo/tabs/tasks/firebase_functions.dart';
import 'package:todo/tabs/tasks/tasks_provider.dart';

class TaskItem extends StatefulWidget {
  TaskItem(this.task);
  TaskModel task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of(context);

    ThemeData theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Slidable(
        key: const ValueKey(0),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(onDismissed: () {}),
          children: [
            SlidableAction(
              onPressed: (context) {
                FirebaseFunctions.deleteTaskFromFirestore(widget.task.id)
                    .timeout(
                  Duration(microseconds: 500),
                  onTimeout: () {
                    Provider.of<TasksProvider>(context, listen: false)
                        .getTasks();
                    Fluttertoast.showToast(
                        msg: "TAsk Deleted",
                        toastLength: Toast.LENGTH_LONG,
                        timeInSecForIosWeb: 5,
                        backgroundColor: AppTheme.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  },
                ).catchError((error) {
                  Fluttertoast.showToast(
                      msg: "Deleted Error ",
                      toastLength: Toast.LENGTH_LONG,
                      timeInSecForIosWeb: 5,
                      backgroundColor: AppTheme.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                });
              },
              backgroundColor: AppTheme.red,
              foregroundColor: AppTheme.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(15),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(EditTaskScreen.routename);
            setState(() {});
          },
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: settingsProvider.isDark ? AppTheme.black : AppTheme.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Container(
                  height: 62,
                  width: 4,
                  color: theme.primaryColor,
                  margin: EdgeInsetsDirectional.only(end: 12),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.task.title,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(color: theme.primaryColor),
                    ),
                    Text(
                      widget.task.description,
                      style: theme.textTheme.titleSmall,
                    ),
                  ],
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    changeStatusTask();
                  },
                  child: widget.task.isDone
                      ? Center(
                          child: Text(
                            'Done!',
                            style: TextStyle(
                              color: AppTheme.green,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : Container(
                          height: 34,
                          width: 69,
                          decoration: BoxDecoration(
                              color: theme.primaryColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Icon(
                            Icons.check,
                            color: AppTheme.white,
                            size: 32,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void changeStatusTask() {
    widget.task.isDone = !widget.task.isDone;
    setState(() {});
  }
}
