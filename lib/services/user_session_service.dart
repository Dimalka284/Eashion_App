import 'package:eashion2/utils/auth_db.dart';
import 'package:sqflite/sqflite.dart';

class UserSessionService{
  // Save token and user id (overwrite if exists)
  Future<void> saveAuth({required int userId, required String token}) async {
    final db = await AuthDb.getDatabase();

    // Clear old token (single-user scenario)
    await db.delete('auth');

    // Insert new token & user id
    await db.insert(
      'auth',
      {'user_id': userId, 'token': token},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get token
  Future<String?> getToken() async {
    final db = await AuthDb.getDatabase();
    final result = await db.query('auth', limit: 1);
    if (result.isNotEmpty) {
      return result.first['token'] as String?;
    }
    return null;
  }

  // Get user id
  Future<int?> getUserId() async {
    final db = await AuthDb.getDatabase();
    final result = await db.query('auth', limit: 1);
    if (result.isNotEmpty) {
      return result.first['user_id'] as int?;
    }
    return null;
  }

  // Delete token (logout)
  Future<void> clearAuth() async {
    final db = await AuthDb.getDatabase();
    await db.delete('auth');
  }
  
}