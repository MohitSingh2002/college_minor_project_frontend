import 'package:avatar_glow/avatar_glow.dart';
import 'package:college_minor_project_frontend/constants/AppStyle.dart';
import 'package:college_minor_project_frontend/constants/Utils.dart';
import 'package:college_minor_project_frontend/widgets/TextFieldCustomWithOutIcon.dart';
import 'package:flutter/material.dart';
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
        onStatus: (val) => print('onStatus: $val'),
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
                    validator: (value) {},
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
