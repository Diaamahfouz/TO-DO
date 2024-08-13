class TaskModel {
  String title;
  String description;
  DateTime date;
  bool isdone;

  TaskModel(
      {required this.title,
      required this.description,
      required this.date,
      this.isdone = false});
}
