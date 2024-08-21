import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/auth/user_provider.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/tabs/settings/settings_provider.dart';
import 'package:todo/tabs/tasks/default_elevated_button.dart';
import 'package:todo/tabs/tasks/default_text_form_field.dart';
import 'package:todo/tabs/tasks/firebase_functions.dart';
import 'package:todo/tabs/tasks/tasks_provider.dart';

class EditTaskScreen extends StatefulWidget {
  static const String routename = '/editTAskScreen';

  const EditTaskScreen({super.key});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TaskModel? task;
  bool isTrue = true;

  @override
  Widget build(BuildContext context) {
    TextStyle? titleMediumStyle = Theme.of(context).textTheme.titleMedium;
    SettingsProvider settingsProvider = Provider.of(context);
    task = ModalRoute.of(context)!.settings.arguments as TaskModel;

    if (isTrue) {
      titleController.text = task!.title;
      descriptionController.text = task!.description;
      selectedDate = task!.date;
      isTrue = false;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        centerTitle: true,
        iconTheme: IconThemeData(
            color: settingsProvider.isDark ? AppTheme.black : AppTheme.white),
        title: Text(
          'TO DO List',
          style: settingsProvider.isDark
              ? titleMediumStyle?.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.black,
                )
              : titleMediumStyle?.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.white,
                ),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            color: AppTheme.primary,
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.06,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: settingsProvider.isDark ? AppTheme.black : AppTheme.white,
            ),
            height: MediaQuery.of(context).size.height * 0.7,
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Edit Task',
                      style: titleMediumStyle,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DefaultTextFormField(
                      controller: titleController,
                      hintText: 'Thie is Title',
                      maxLines: 1,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Title can not be empty !';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DefaultTextFormField(
                      controller: descriptionController,
                      hintText: 'Task Description',
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Description can not be empty !';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    Text(
                      'Select Date',
                      style: titleMediumStyle,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    InkWell(
                      onTap: () async {
                        DateTime? dateTime = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                          initialDate: selectedDate,
                          initialEntryMode: DatePickerEntryMode.calendarOnly,
                        );
                        if (dateTime != null) {
                          selectedDate = dateTime;
                          setState(() {});
                        }
                      },
                      child: Text(
                        dateFormat.format(selectedDate),
                        style: titleMediumStyle?.copyWith(
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                    DefaultElevatedButton(
                        label: 'Save Changes',
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            editTask();
                          }
                        })
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> editTask() async {
    final userId =
        Provider.of<UserProvider>(context, listen: false).currentUser!.id;

    task!.title = titleController.text;
    task!.description = descriptionController.text;
    task!.date = selectedDate;
    await FirebaseFunctions.editTaskToFireStore(
      task!,
      userId,
    ).then(
      (_) {
        Navigator.of(context).pop();
        Provider.of<TasksProvider>(context, listen: false).getTasks(userId);
        Fluttertoast.showToast(
            msg: "Task Edited Successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: AppTheme.green,
            textColor: AppTheme.white,
            fontSize: 16.0);
      },
    ).catchError((error) {
      Fluttertoast.showToast(
          msg: "Something Went Wrong!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: AppTheme.red,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }
}
