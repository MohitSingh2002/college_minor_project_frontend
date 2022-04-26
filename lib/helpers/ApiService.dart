import 'dart:convert';

import 'package:college_minor_project_frontend/models/Task.dart';
import 'package:http/http.dart' as http;

class ApiService {

  String URL = 'https://college-minor-project-backend.herokuapp.com';

  Future<bool> addTask(Task task) async {
    Uri url = Uri.parse('$URL/task/addTask');
    var response = await http.post(url, body: json.encode(task.toAddTaskJson()), headers: {'Content-type': 'application/json'});
    return response.statusCode == 200;
  }
  
  Future<List<Task>> getAllTasks(String email) async {
    Uri url = Uri.parse('$URL/task/getAllTasks/$email');
    var response = await http.get(url);
    List<Task> list = [];
    for (var data in json.decode(response.body)['tasks']) {
      list.add(Task.fromJson(data));
    }
    return list;
  }

  Future<bool> deleteTask(String id) async {
    Uri url = Uri.parse('$URL/task/deleteTask/$id');
    var response = await http.delete(url);
    return response.statusCode == 200;
  }

}
