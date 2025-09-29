import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/restaurant.dart';

class FavoriteDbHelper {
  static FavoriteDbHelper? _instance;
  static Database? _database;

  FavoriteDbHelper._internal() {
    _instance = this;
  }

  factory FavoriteDbHelper() => _instance ?? FavoriteDbHelper._internal();

  Future<Database> get database async {
    _database ??= await _initDb();
    return _database!;
  }

  static const String _tableName = 'favorites';
  static const int _databaseVersion = 2; // versi baru

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'restaurant.db');
    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id TEXT PRIMARY KEY,
            name TEXT,
            description TEXT,
            pictureId TEXT,
            city TEXT,
            address TEXT,
            rating REAL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Tambahkan kolom address jika database lama versi 1
          await db.execute('ALTER TABLE $_tableName ADD COLUMN address TEXT;');
        }
      },
    );
  }

  Future<void> insertFavorite(Restaurant restaurant) async {
    final db = await database;
    await db.insert(
      _tableName,
      restaurant.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(String id) async {
    final db = await database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>?> getFavoriteById(String id) async {
    final db = await database;
    final result = await db.query(_tableName, where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) return result.first;
    return null;
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await database;
    return db.query(_tableName);
  }
}
