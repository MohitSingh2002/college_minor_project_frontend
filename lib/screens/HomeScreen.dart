import 'package:college_minor_project_frontend/constants/AppStyle.dart';
import 'package:college_minor_project_frontend/constants/Utils.dart';
import 'package:college_minor_project_frontend/helpers/ApiService.dart';
import 'package:college_minor_project_frontend/helpers/FirebaseAuthHelper.dart';
import 'package:college_minor_project_frontend/helpers/PrefsHelper.dart';
import 'package:college_minor_project_frontend/models/Task.dart';
import 'package:college_minor_project_frontend/providers/EmailProvider.dart';
import 'package:college_minor_project_frontend/providers/TasksProvider.dart';
import 'package:college_minor_project_frontend/screens/AddTaskChatScreen.dart';
import 'package:college_minor_project_frontend/screens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool isLoading = false;
  List<Task> tasksList = [];

  @override
  void initState() {
    super.initState();
    getEmailFromSharedPrefs();
  }

  void getEmailFromSharedPrefs() async {
    setState(() {
      isLoading = true;
    });
    String email = await PrefsHelper().getEmail();
    setState(() {
      isLoading = false;
    });
    Provider.of<EmailProvider>(context, listen: false).setEmail(email);
    getAllTasks();
  }

  void getAllTasks() {
    setState(() {
      isLoading = true;
    });
    ApiService().getAllTasks(Provider.of<EmailProvider>(context, listen: false).getEmail()).then((value) {
      Provider.of<TasksProvider>(context, listen: false).addList(value);
      setState(() {
        tasksList = value;
        isLoading = false;
      });
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      Utils.showToast(message: 'Some error occurred, please try again later');
    });
  }

  void deleteTask(Task task, int index) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            'Are you sure you want to delete this task ?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'NO',
                style: TextStyle(
                  color: AppStyle.red,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Provider.of<TasksProvider>(context, listen: false).removeTask(index);
                Navigator.pop(context);
                ApiService().deleteTask(task.id as String).then((value) {
                }).catchError((onError) {
                  Provider.of<TasksProvider>(context, listen: false).addTaskAt(task, index);
                  Utils.showToast(message: 'Some error occurred, please try again later');
                });
              },
              child: Text(
                'YES',
                style: TextStyle(
                  color: AppStyle.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void updateTaskToCompleted(Task task, int index) {
    task.isCompleted = 'true';
    Provider.of<TasksProvider>(context, listen: false).updateAt(task, index);
    ApiService().updateTask(task.id as String).then((value) {}).catchError((onError) {
      task.isCompleted = 'false';
      Provider.of<TasksProvider>(context, listen: false).updateAt(task, index);
      Utils.showToast(message: 'Some error occurred, please try again later');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.purple_bg,
      appBar: AppBar(
        backgroundColor: AppStyle.purple_light,
        title: Text(
          'Tasks',
          style: TextStyle(
            color: AppStyle.white,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              PrefsHelper().clearAll();
              FirebaseAuthHelper().logout().then((value) {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
              });
            },
            icon: Icon(Icons.exit_to_app, color: AppStyle.white,),
          ),
        ],
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            backgroundColor: AppStyle.purple_light,
            child: Icon(Icons.keyboard_voice,),
            onPressed: () {},
            heroTag: 'Add task using voice',
          ),
          SizedBox(
            height: Utils.width(context) / 90.0,
          ),
          FloatingActionButton(
            backgroundColor: AppStyle.purple_light,
            child: Icon(Icons.add,),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddTaskChatScreen()));
            },
            heroTag: 'Add task',
          ),
        ],
      ),
      body: SafeArea(
        child: isLoading ? Center(
          child: CircularProgressIndicator(
            color: AppStyle.red,
          ),
        ) : context.watch<TasksProvider>().getTaskList().isEmpty ? Center(
          child: Text(
            'No Pending Tasks Found',
            style: TextStyle(
              color: AppStyle.white,
            ),
          ),
        ) : SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.all(Utils.width(context) / 30.0,),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: context.watch<TasksProvider>().getTaskList().length,
                  itemBuilder: (context, index) {
                    Task task = context.watch<TasksProvider>().getTaskList().elementAt(index);
                    return Card(
                      color: AppStyle.purple_light,
                      child: ListTile(
                        leading: Checkbox(
                          value: task.isCompleted == 'true',
                          activeColor: AppStyle.red,
                          onChanged: (value) {
                            setState(() {
                              if (task.isCompleted == 'true') {
                                task.isCompleted = 'false';
                                Provider.of<TasksProvider>(context, listen: false).updateAt(task, index);
                              } else {
                                updateTaskToCompleted(task, index);
                              }
                            });
                          },
                        ),
                        title: Text(
                          '${task.task}',
                          style: TextStyle(
                            color: AppStyle.white,
                            fontWeight: FontWeight.bold,
                            decoration: task.isCompleted == 'true' ? TextDecoration.lineThrough : TextDecoration.none,
                            fontSize: 20.0,
                          ),
                        ),
                        subtitle: Text(
                          'Estimated Time: ${task.estimatedCompletionTime}',
                          style: TextStyle(
                            color: AppStyle.white,
                            decoration: task.isCompleted == 'true' ? TextDecoration.lineThrough : TextDecoration.none,
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            deleteTask(task, index);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: AppStyle.red,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
