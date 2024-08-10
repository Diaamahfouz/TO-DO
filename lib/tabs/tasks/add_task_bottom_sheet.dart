import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/tabs/tasks/default_elevated_button.dart';
import 'package:todo/tabs/tasks/default_text_form_field.dart';

class AddTaskBottomSheet extends StatefulWidget {
  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextStyle? titleMediumStyle = Theme.of(context).textTheme.titleMedium;
    return Container(
      padding: EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.55,
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Text(
              'Add New Task',
              style: titleMediumStyle,
            ),
            SizedBox(
              height: 16,
            ),
            DefaultTextFormField(
              controller: titleController,
              hintText: 'Enter Task Title',
              maxLines: 1,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Title can not be empty !';
                }
                return null;
              },
            ),
            SizedBox(
              height: 16,
            ),
            DefaultTextFormField(
              controller: descriptionController,
              hintText: 'Enter Task Description',
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Description can not be empty !';
                }
                return null;
              },
            ),
            SizedBox(
              height: 16,
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
                style: titleMediumStyle?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            DefaultElevatedButton(
                label: 'Submit',
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    addTask();
                  }
                })
          ],
        ),
      ),
    );
  }

  void addTask() {
    print('task added');
  }
}
