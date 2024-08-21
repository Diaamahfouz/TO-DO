import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/auth/user_provider.dart';
import 'package:todo/tabs/settings/settings_provider.dart';
import 'package:todo/tabs/tasks/task_item.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:todo/tabs/tasks/tasks_provider.dart';

class TasksTab extends StatefulWidget {
  const TasksTab({super.key});

  @override
  State<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  bool shouldGetTasks = true;
  @override
  Widget build(BuildContext context) {
    TasksProvider tasksProvider = Provider.of<TasksProvider>(context);
    SettingsProvider settingsProvider = Provider.of(context);
    if (shouldGetTasks) {
      final userId = Provider.of<UserProvider>(context).currentUser!.id;
      tasksProvider.getTasks(userId);
      shouldGetTasks = false;
    }

    return Column(children: [
      Stack(
        children: [
          Container(
            color: AppTheme.primary,
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.06,
          ),
          EasyInfiniteDateTimeLine(
            firstDate: DateTime.now().subtract(const Duration(days: 365)),
            focusDate: tasksProvider.selectedDate,
            activeColor:
                settingsProvider.isDark ? AppTheme.white : AppTheme.white,
            lastDate: DateTime.now().add(const Duration(days: 365)),
            showTimelineHeader: false,
            onDateChange: (selectedDate) {
              tasksProvider.changeSelecteDate(selectedDate);
              tasksProvider.getTasks(
                Provider.of<UserProvider>(context, listen: false)
                    .currentUser!
                    .id,
              );
            },
            dayProps: EasyDayProps(
              dayStructure: DayStructure.dayStrDayNum,
              height: 90,
              width: 60,
              activeDayStyle: DayStyle(
                decoration: BoxDecoration(
                  color:
                      settingsProvider.isDark ? AppTheme.black : AppTheme.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                dayStrStyle: TextStyle(
                  color: settingsProvider.isDark
                      ? AppTheme.primary
                      : AppTheme.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                dayNumStyle: TextStyle(
                  color: settingsProvider.isDark
                      ? AppTheme.primary
                      : AppTheme.primary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              inactiveDayStyle: DayStyle(
                decoration: BoxDecoration(
                  color:
                      settingsProvider.isDark ? AppTheme.black : AppTheme.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                dayStrStyle: TextStyle(
                  color:
                      settingsProvider.isDark ? AppTheme.white : AppTheme.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                dayNumStyle: TextStyle(
                  color:
                      settingsProvider.isDark ? AppTheme.white : AppTheme.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              todayStyle: DayStyle(
                dayNumStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color:
                      settingsProvider.isDark ? AppTheme.white : AppTheme.black,
                ),
                dayStrStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color:
                      settingsProvider.isDark ? AppTheme.white : AppTheme.black,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color:
                      settingsProvider.isDark ? AppTheme.black : AppTheme.white,
                ),
              ),
            ),
          ),
        ],
      ),
      Expanded(
          child: ListView.builder(
        padding: const EdgeInsets.only(top: 20),
        itemBuilder: (_, index) => TaskItem(tasksProvider.tasks[index]),
        itemCount: tasksProvider.tasks.length,
      ))
    ]);
  }
}
