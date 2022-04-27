import 'package:avatar_glow/avatar_glow.dart';
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
import 'package:speech_to_text/speech_to_text.dart';

class AddTaskVoiceScreen extends StatefulWidget {
  const AddTaskVoiceScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskVoiceScreen> createState() => _AddTaskVoiceScreenState();
}

class _AddTaskVoiceScreenState extends State<AddTaskVoiceScreen> {

  bool isLoading = false;
  TextEditingController taskController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isListening = false;
  String voiceText = '';
  SpeechToText speechToText = SpeechToText();

  void listen() async {
    if (!isListening) {
      bool available = await speechToText.initialize(
        onStatus: (val) {
          print('onStatus: $val');
          if (val == 'done') {
            setState(() {
              isListening = false;
            });
            speechToText.stop();
          }
        },
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => isListening = true);
        speechToText.listen(
          onResult: (val) => setState(() {
            voiceText = val.recognizedWords;
            taskController = TextEditingController(text: voiceText);
          }),
        );
      }
    } else {
      setState(() => isListening = false);
      speechToText.stop();
    }
  }

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
                    keyboardType: TextInputType.text,
                    hintText: 'Tap to start voice task',
                    maxLines: 10,
                    readOnly: true,
                    onTap: () {},
                    validator: (value) {
                      if (value != null) {
                        if (value.isEmpty) {
                          return 'Please tap mic button to record your task';
                        }
                      }
                    },
                  ),
                  SizedBox(
                    height: Utils.width(context) / 30.0,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        listen();
                      },
                      child: AvatarGlow(
                        repeat: isListening,
                        endRadius: 60.0,
                        child: Material(
                          elevation: 8.0,
                          shape: CircleBorder(),
                          child: CircleAvatar(
                            backgroundColor: AppStyle.purple_light,
                            child: Icon(Icons.mic, color: AppStyle.white,),
                            radius: 30.0,
                          ),
                        ),
                      ),
                    ),
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
