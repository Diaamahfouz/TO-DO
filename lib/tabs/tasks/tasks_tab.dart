import 'package:flutter/material.dart';
import 'package:todo/tabs/tasks/task_item.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';

class TasksTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(children: [
        EasyInfiniteDateTimeLine(
          firstDate: DateTime.now().subtract(Duration(days: 365)),
          focusDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 365)),
          showTimelineHeader: false,
        ),
        Expanded(
            child: ListView.builder(
          padding: EdgeInsets.only(top: 20),
          itemBuilder: (_, index) => TaskItem(),
          itemCount: 10,
        ))
      ]),
    );
  }
}
