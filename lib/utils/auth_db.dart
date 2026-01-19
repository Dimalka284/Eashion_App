import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AuthDb {
  static Database? _globalDb;

  static Future<Database> getDatabase() async {
    if (_globalDb != null) return _globalDb!;

    _globalDb = await _initDatabase();
    return _globalDb!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'AuthDB.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE auth (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            name TEXT,
            token TEXT
          )
        ''');
      },
    );
  }
}
