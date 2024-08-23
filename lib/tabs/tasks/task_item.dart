import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/auth/user_provider.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/tabs/settings/settings_provider.dart';
import 'package:todo/tabs/tasks/edit_task_screen.dart';
import 'package:todo/tabs/tasks/firebase_functions.dart';
import 'package:todo/tabs/tasks/tasks_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskItem extends StatefulWidget {
  const TaskItem(this.task, {super.key});
  final TaskModel task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of(context);

    ThemeData theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Slidable(
        key: const ValueKey(0),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) {
                final userId = Provider.of<UserProvider>(context, listen: false)
                    .currentUser!
                    .id;
                FirebaseFunctions.deleteTaskFromFirestore(
                        widget.task.id, userId)
                    .then(
                  (_) {
                    Provider.of<TasksProvider>(context, listen: false)
                        .getTasks(userId);
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
              label: AppLocalizations.of(context)!.delte,
              borderRadius: BorderRadius.circular(15),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(EditTaskScreen.routename, arguments: widget.task);

          },
          child: Container(
            padding: const EdgeInsets.all(20),
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
                  margin: const EdgeInsetsDirectional.only(end: 12),
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
                      style: TextStyle(
                        color: settingsProvider.isDark
                            ? AppTheme.white
                            : AppTheme.black,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    changeStatusTask();
                  },
                  child: widget.task.isDone
                      ? Center(
                          child: Text(
                            AppLocalizations.of(context)!.isDone,
                            style: const TextStyle(
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
                          child: const Icon(
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

  Future<void> changeStatusTask() async {
    widget.task.isDone = !widget.task.isDone;
    setState(() {});
    final userId =
        Provider.of<UserProvider>(context, listen: false).currentUser!.id;

    await FirebaseFunctions.editTaskToFireStore(widget.task, userId);
    // ignore: use_build_context_synchronously
    Provider.of<TasksProvider>(context, listen: false).getTasks(userId);
  }
}
