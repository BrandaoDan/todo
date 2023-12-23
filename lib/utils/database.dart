import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  late Database _db;

  Future<Database> get db async {
    if (_db.isOpen) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'todo.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE todo (
            id INTEGER PRIMARY KEY,
            title TEXT,
            done TEXT
          )
        ''');
      },
    );
    return _db;
  }

  Future<void> addItem(String title, bool done) async {
    final db = await this.db;
    await db.insert('todo', {'title': title, 'done': done.toString()});
  }

  Future<List<Map<String, dynamic>>> getItems() async {
    final db = await this.db;
    return db.query('todo');
  }

  Future<void> updateItem(int id, bool done) async {
    final db = await this.db;
    await db.update('todo', {'done': done.toString()},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteItem(int id) async {
    final db = await this.db;
    await db.delete('todo', where: 'id = ?', whereArgs: [id]);
  }
}
