import 'package:college_minor_project_frontend/models/Task.dart';
import 'package:flutter/material.dart';

class TasksProvider extends ChangeNotifier {

  List<Task> tasksList = [];

  void addList(List<Task> list) {
    tasksList = list;
    notifyListeners();
  }

  void addTask(Task task) {
    tasksList.insert(0, task);
    notifyListeners();
  }

  void removeTask(int index) {
    tasksList.removeAt(index);
    notifyListeners();
  }

  List<Task> getTaskList() {
    return tasksList;
  }

}
