import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/tabs/settings/settings_provider.dart';

class TaskItem extends StatelessWidget {
  TaskItem(this.task);
  TaskModel task;
  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of(context);
    ThemeData theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
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
                task.title,
                style: theme.textTheme.titleMedium
                    ?.copyWith(color: theme.primaryColor),
              ),
              Text(
                task.description,
                style: theme.textTheme.titleSmall,
              ),
            ],
          ),
          Spacer(),
          InkWell(
            onTap: () {},
            child: Container(
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
    );
  }
}
