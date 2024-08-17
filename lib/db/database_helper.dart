import 'dart:ffi';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/model/task.dart';

class DatabaseHelper{

  static const _databaseName = "todo_app.db";
  static const _databaseVersion = 1;


  static const todo_table = 'todo_table';
  static const task_table = 'task_table';

  //User
  static const columnId = '_id';
  static const columnName = 'name';
  static const columnEmail = 'email';
  static const columnPhoneNo = 'phoneNo';
  static const columnAddress = 'address';
  static const columnPassword = 'password';

  late Database _db;

  // this opens the database (and creates it if it doesn't exist)
  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    // await db.execute('''
    //       CREATE TABLE $todo_table (ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    //         $columnName TEXT NOT NULL,
    //         $columnEmail TEXT NOT NULL,
    //         $columnPhoneNo TEXT NOT NULL,
    //         $columnAddress TEXT NOT NULL,
    //         $columnPassword TEXT NOT NULL
    //       )
    //       ''');

    await db.execute('''
          CREATE TABLE $task_table (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
           title TEXT NOT NULL,
            isDone TEXT NOT NULL,
            dateTime TEXT NOT NULL
        )
          ''');
  }

  Future<int> createTask(Map<String, dynamic> row) async{
    return await _db.insert(task_table, row);
  }

  Future<List<Map<String, dynamic>>> getAllTask() async {
    return await _db.query(task_table);
  }

  Future<List<Task>> getTaskList() async {
    final List<Map<String, dynamic>> maps = await _db.query(task_table);

    // Convert the List<Map<String, dynamic> into a List<Task>.
    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  Future<int> deleteTask(int task_id) async {
    return await _db.delete(
      task_table,
      where: 'id = ?',
      whereArgs: [task_id],
    );
  }

  // Future<int> markAsDoneTask(int task_id) async {
  //   return await _db.update(
  //     task_table,
  //     where: 'isDone = ?',
  //     whereArgs: [1],
  //   );
  // }

  Future<int> markAsDoneTask(Map<String, dynamic> row) async {
    int id = row["id"];
    return await _db.update(
      task_table,
      row,
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  Future<int> insertTask(Map<String, dynamic> row) async {
    return await _db.insert(todo_table, row);
  }


  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return await _db.query(todo_table);
  }

}