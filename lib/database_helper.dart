import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'task_model.dart';

class DatabaseHelper {
  static const _databaseName = "StudyTimer.db";

  static const _databaseVersion = 1;

  static const table = 'tasks';

  static const columnId = 'id';
  static const columnTitle = 'title';
  static const columnPomodoroCount = 'pomodoroCount';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnTitle TEXT NOT NULL,
            $columnPomodoroCount INTEGER DEFAULT 0 
          )
          ''');
  }

  Future<int> insert(Task task) async {
    Database db = await instance.database;

    return await db.insert(table, task.toMap());
  }

  Future<List<Task>> getAllTasks() async {
    Database db = await instance.database;

    final List<Map<String, dynamic>> maps = await db.query(table);

    if (maps.isEmpty) {
      return [];
    }

    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Task task) async {
    Database db = await instance.database;
    int id = task.id!;
    return await db.update(
      table,
      task.toMap(),
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
