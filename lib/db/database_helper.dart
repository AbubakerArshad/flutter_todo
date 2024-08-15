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

  Future<int> insertTask(Map<String, dynamic> row) async {
    return await _db.insert(todo_table, row);
  }


  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return await _db.query(todo_table);
  }

}