import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:eventandticketbookingsystem/models/event_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('bookings.db');
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

  // CREATE TABLE with an auto-incrementing primary key ID
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE bookings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        attendeeName TEXT NOT NULL,
        ticketCount INTEGER NOT NULL,
        eventTitle TEXT NOT NULL
      )
    ''');
  }

  // ==========================================
  //            DATABASE CRUD OPERATIONS
  // ==========================================

  // 1. CREATE: Insert a new booking record
  Future<int> createBooking(TicketBooking booking) async {
    final db = await instance.database;
    return await db.insert('bookings', booking.toMap());
  }

  // 2. READ: Fetch all saved bookings
  Future<List<TicketBooking>> readAllBookings() async {
    final db = await instance.database;
    final result = await db.query('bookings', orderBy: 'id DESC');

    return result.map((json) => TicketBooking.fromMap(json)).toList();
  }

  // 3. UPDATE: Modify an existing ticket reservation
  Future<int> updateBooking(TicketBooking booking) async {
    final db = await instance.database;
    return await db.update(
      'bookings',
      booking.toMap(),
      where: 'id = ?',
      whereArgs: [booking.id],
    );
  }

  // 4. DELETE: Wipe out a ticket entry
  Future<int> deleteBooking(int id) async {
    final db = await instance.database;
    return await db.delete(
      'bookings',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 5. SEARCH: Filter bookings by attendee name or event title
  Future<List<TicketBooking>> searchBookings(String query) async {
    final db = await instance.database;
    final result = await db.query(
      'bookings',
      where: 'attendeeName LIKE ? OR eventTitle LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );

    return result.map((json) => TicketBooking.fromMap(json)).toList();
  }
}