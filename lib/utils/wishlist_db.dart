import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class  WishlistDB {
  static Database? _globalDb;

  static Future<Database> getDatabase() async {
    if (_globalDb != null) return _globalDb!;

    _globalDb = await _initDatabase();
    return _globalDb!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'WishlistDB');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE wishlist (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            product_id INTEGER UNIQUE,
            name TEXT,
            price REAL,
            image_url TEXT,
            discount REAL
          )
        ''');
      },
    );
  }
}
