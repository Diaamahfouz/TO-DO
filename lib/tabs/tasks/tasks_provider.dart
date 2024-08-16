import 'package:flutter/material.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/tabs/tasks/firebase_functions.dart';

class TasksProvider with ChangeNotifier {
  List<TaskModel> tasks = [];
  DateTime selectedDate = DateTime.now();

  Future<void> getTasks() async {
    List<TaskModel> allTasks =
        await FirebaseFunctions.getAllTasksFromFirestore();
    tasks = allTasks
        .where((task) =>
            task.date.day == selectedDate.day &&
            task.date.month == selectedDate.month &&
            task.date.year == selectedDate.year)
        .toList();
    notifyListeners();
  }

  void changeSelecteDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }
}
