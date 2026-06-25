import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton pattern to ensure only one database instance exists
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('events.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE bookings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user TEXT,
        event TEXT,
        count TEXT,
        price TEXT
      )
    ''');
  }

  // CREATE: Add a new booking
  Future<int> addBooking(Map<String, dynamic> booking) async {
    final db = await instance.database;
    return await db.insert('bookings', booking);
  }

  // READ: Fetch all bookings
  Future<List<Map<String, dynamic>>> getBookings() async {
    final db = await instance.database;
    return await db.query('bookings');
  }

  // DELETE: Remove a booking by ID
  Future<int> deleteBooking(int id) async {
    final db = await instance.database;
    return await db.delete(
      'bookings',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Close the database
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}