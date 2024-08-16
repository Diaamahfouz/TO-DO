import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/tabs/settings/settings_provider.dart';
import 'package:todo/tabs/tasks/task_item.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:todo/tabs/tasks/tasks_provider.dart';

class TasksTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TasksProvider tasksProvider = Provider.of<TasksProvider>(context);
    SettingsProvider settingsProvider = Provider.of(context);

    return Column(children: [
      SizedBox(
        height: 15,
      ),
      EasyInfiniteDateTimeLine(
        firstDate: DateTime.now().subtract(Duration(days: 365)),
        focusDate: tasksProvider.selectedDate,
        activeColor:
            settingsProvider.isDark ? AppTheme.primary : AppTheme.primary,
        lastDate: DateTime.now().add(Duration(days: 365)),
        showTimelineHeader: false,
        onDateChange: (selectedDate) {
          tasksProvider.changeSelecteDate(selectedDate);
          tasksProvider.getTasks();
        },
      ),
      Expanded(
          child: ListView.builder(
        padding: EdgeInsets.only(top: 20),
        itemBuilder: (_, index) => TaskItem(tasksProvider.tasks[index]),
        itemCount: tasksProvider.tasks.length,
      ))
    ]);
  }
}
