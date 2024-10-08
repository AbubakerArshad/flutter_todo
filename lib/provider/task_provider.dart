

import 'package:flutter/cupertino.dart';
import 'package:todo_app/main.dart';

import '../model/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  Future<void> loadTasks() async {
    _tasks = await dbHelper.getTaskList();
    notifyListeners();
  }

  void addTask(Task task) {
    Map<String, dynamic> row = {
      "title": task.title,
      "isDone": task.isDone,
      "dateTime": task.dateTime
    };
    dbHelper.createTask(row);
    notifyListeners();
  }

  void deleteTask(int task_id){
    dbHelper.deleteTask(task_id);
    notifyListeners();
  }

  void markAsDoneTask(Task task){
    Map<String, dynamic> row = {
      "id": task.id,
      "title": task.title,
      "isDone": task.isDone == 1 ? 0 :1,
      "dateTime": task.dateTime
    };
    dbHelper.markAsDoneTask(row);
    notifyListeners();
  }

// Implement methods to update and delete tasks

// You can also add methods for fetching and managing tasks
}