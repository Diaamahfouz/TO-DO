import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/app_theme.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/tabs/settings/settings_provider.dart';
import 'package:todo/tabs/tasks/default_elevated_button.dart';
import 'package:todo/tabs/tasks/default_text_form_field.dart';
import 'package:todo/tabs/tasks/firebase_functions.dart';
import 'package:todo/tabs/tasks/tasks_provider.dart';

class EditTaskScreen extends StatefulWidget {
  static const String routename = '/editTAskScreen';

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    TextStyle? titleMediumStyle = Theme.of(context).textTheme.titleMedium;
    SettingsProvider settingsProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        centerTitle: true,
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
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
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
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Edit Task',
                      style: titleMediumStyle,
                    ),
                    SizedBox(
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
                    SizedBox(
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
                    SizedBox(
                      height: 35,
                    ),
                    Text(
                      'Select Date',
                      style: titleMediumStyle,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    InkWell(
                      onTap: () async {
                        DateTime? dateTime = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365)),
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
                    SizedBox(
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

  void editTask() {
    FirebaseFunctions.editTaskToFireStore(
      TaskModel(
        title: titleController.text,
        description: descriptionController.text,
        date: selectedDate,
      ),
    ).timeout(
      Duration(microseconds: 500),
      onTimeout: () {
        Navigator.of(context).pop();
        Provider.of<TasksProvider>(context, listen: false).getTasks();
        Fluttertoast.showToast(
            msg: "Task Added Successfully",
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
