import 'package:college_minor_project_frontend/constants/AppStyle.dart';
import 'package:college_minor_project_frontend/constants/Utils.dart';
import 'package:college_minor_project_frontend/helpers/ApiService.dart';
import 'package:college_minor_project_frontend/models/Task.dart';
import 'package:college_minor_project_frontend/providers/EmailProvider.dart';
import 'package:college_minor_project_frontend/providers/TasksProvider.dart';
import 'package:college_minor_project_frontend/widgets/TextFieldCustomWithOutIcon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddTaskChatScreen extends StatefulWidget {
  const AddTaskChatScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskChatScreen> createState() => _AddTaskChatScreenState();
}

class _AddTaskChatScreenState extends State<AddTaskChatScreen> {

  bool isLoading = false;
  TextEditingController taskController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.purple_bg,
      appBar: AppBar(
        backgroundColor: AppStyle.purple_light,
        title: Text(
          'Add Task',
          style: TextStyle(
            color: AppStyle.white,
          ),
        ),
      ),
      body: SafeArea(
        child: isLoading ? Center(
          child: CircularProgressIndicator(
            color: AppStyle.red,
          ),
        ) : Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.all(Utils.width(context) / 30.0,),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFieldCustomWithOutIcon(
                    controller: taskController,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    hintText: 'Enter task',
                    readOnly: false,
                    onTap: () {},
                    validator: (value) {
                      if (value != null) {
                        if (value.isEmpty) {
                          return 'Can\'t be empty';
                        }
                      }
                    },
                  ),
                  SizedBox(
                    height: Utils.width(context) / 30.0,
                  ),
                  TextFieldCustomWithOutIcon(
                    controller: dateController,
                    keyboardType: TextInputType.text,
                    hintText: 'Pick completion date and time',
                    readOnly: true,
                    onTap: () {
                      DatePicker.showDateTimePicker(
                        context,
                        theme: DatePickerTheme(
                          doneStyle: TextStyle(
                            color: AppStyle.red,
                          ),
                        ),
                        onConfirm: (dateTime) {
                          setState(() {
                            dateController = TextEditingController(text: DateFormat('d/M/yyyy hh:mm a').format(dateTime));
                          });
                        }
                      );
                    },
                    validator: (value) {
                      if (value != null) {
                        if (value.isEmpty) {
                          return 'Can\'t be empty';
                        }
                      }
                    },
                  ),
                  SizedBox(
                    height: Utils.width(context) / 10.0,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          Task task = Task.addTask(
                            email: Provider.of<EmailProvider>(context, listen: false).getEmail(),
                            task: taskController.text.toString(),
                            isCompleted: 'false',
                            estimatedCompletionTime: dateController.text.toString(),
                          );
                          ApiService().addTask(task).then((value) {
                            Provider.of<TasksProvider>(context, listen: false).addTask(value);
                            Utils.showToast(message: 'Task Added Successfully');
                            Navigator.pop(context);
                          }).catchError((onError) {
                            print('onError : ${onError}');
                            setState(() {
                              isLoading = false;
                            });
                            Utils.showToast(message: 'Some error occurred, please try again later');
                          });
                        }
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(
                          color: AppStyle.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: AppStyle.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
