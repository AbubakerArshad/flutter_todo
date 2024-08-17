
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/model/notes.dart';
import 'package:todo_app/model/task.dart';

class DatabaseHelper{

  static const _databaseName = "todo_app.db";
  static const _databaseVersion = 1;


  static const note_table = 'note_table';
  static const task_table = 'task_table';

  //NOTES
  static const noteColumnId = 'id';
  static const noteColumnTitle = 'title';
  static const noteColumnDescription = 'description';
  static const noteColumnDateTime = 'dateTime';

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
    await db.execute('''
          CREATE TABLE $note_table (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            $noteColumnTitle TEXT NOT NULL,
            $noteColumnDescription TEXT NOT NULL,
            $noteColumnDateTime TEXT NOT NULL
          )
          ''');

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

  Future<int> markAsDoneTask(Map<String, dynamic> row) async {
    int id = row["id"];
    return await _db.update(
      task_table,
      row,
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  //NOTES
  Future<int> createNote(Map<String, dynamic> row) async{
    return await _db.insert(note_table, row);
  }

  Future<List<Notes>> getNotesList() async {
    final List<Map<String, dynamic>> maps = await _db.query(note_table);

    // Convert the List<Map<String, dynamic> into a List<Task>.
    return List.generate(maps.length, (i) {
      return Notes.fromMap(maps[i]);
    });
  }

  Future<int> deleteNote(int note_id) async {
    return await _db.delete(
      note_table,
      where: 'id = ?',
      whereArgs: [note_id],
    );
  }


}