import 'dart:convert';

Task taskFromJson(String str) => Task.fromJson(json.decode(str));

String taskToJson(Task data) => json.encode(data.toJson());

class Task {
  Task({
    required this.id,
    required this.email,
    required this.task,
    required this.isCompleted,
    required this.estimatedCompletionTime,
    required this.estimatedTime,
    required this.updationTime,
    required this.createdAt,
    required this.updatedAt,
  });

  Task.addTask({this.email, this.task, this.isCompleted, this.estimatedCompletionTime});

  String? id;
  String? email;
  String? task;
  String? isCompleted;
  String? estimatedCompletionTime;
  DateTime? estimatedTime;
  String? updationTime;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json["_id"],
    email: json["email"],
    task: json["task"],
    isCompleted: json["isCompleted"],
    estimatedCompletionTime: json["estimatedCompletionTime"],
    estimatedTime: DateTime.parse(json["estimatedTime"]),
    updationTime: json["updationTime"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "email": email,
    "task": task,
    "isCompleted": isCompleted,
    "estimatedCompletionTime": estimatedCompletionTime,
    "estimatedTime": estimatedTime!.toIso8601String(),
    "updationTime": updationTime,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
  };

  Map<String, dynamic> toAddTaskJson() => {
    "email": email,
    "task": task,
    "isCompleted": isCompleted,
    "estimatedCompletionTime": estimatedCompletionTime,
  };

  @override
  String toString() {
    return 'Task{id: $id, email: $email, task: $task, isCompleted: $isCompleted, estimatedCompletionTime: $estimatedCompletionTime, estimatedTime: $estimatedTime, updationTime: $updationTime, createdAt: $createdAt, updatedAt: $updatedAt}';
  }

}
