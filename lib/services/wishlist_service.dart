
import 'package:eashion2/utils/wishlist_db.dart';
import 'package:sqflite/sqflite.dart';

class WishlistService {
  Future<void> addToWishlist(Map<String, dynamic> product) async {
    final db = await WishlistDB.getDatabase();

    await db.insert(
      'wishlist',
      product,
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> removeFromWishlist(int productId) async {
    final db = await WishlistDB.getDatabase();

    await db.delete(
      'wishlist',
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  }

  Future<bool> isWishlisted(int productId) async {
    final db = await WishlistDB.getDatabase();

    final result = await db.query(
      'wishlist',
      where: 'product_id = ?',
      whereArgs: [productId],
    );

    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getWishlist() async {
    final db = await WishlistDB.getDatabase();
    return await db.query('wishlist');
  }
}
