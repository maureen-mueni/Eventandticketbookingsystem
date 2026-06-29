import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

// ==========================================================================
// 1. DATA MODEL CLASS (Saves fields inline so no external files are broken)
// ==========================================================================
class InlineTicketBooking {
  final int? id;
  final String attendeeName;
  final int ticketCount;
  final String eventTitle;

  InlineTicketBooking({
    this.id,
    required this.attendeeName,
    required this.ticketCount,
    required this.eventTitle,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'attendeeName': attendeeName,
      'ticketCount': ticketCount,
      'eventTitle': eventTitle,
    };
  }

  factory InlineTicketBooking.fromMap(Map<String, dynamic> map) {
    return InlineTicketBooking(
      id: map['id'] as int?,
      attendeeName: map['attendeeName'] as String,
      ticketCount: map['ticketCount'] as int,
      eventTitle: map['eventTitle'] as String,
    );
  }
}

// ==========================================================================
// 2. MAIN WIDGET SCREEN
// ==========================================================================
class BookingFormScreen extends StatefulWidget {
  final String eventTitle;

  const BookingFormScreen({super.key, required this.eventTitle});

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ticketController = TextEditingController(text: '1');
  final _searchController = TextEditingController();

  Database? _db;
  List<InlineTicketBooking> _savedBookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initLocalDatabase();
  }

  // Initializes SQLite connection internally
  Future<void> _initLocalDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'bookings_v2.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE records (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            attendeeName TEXT NOT NULL,
            ticketCount INTEGER NOT NULL,
            eventTitle TEXT NOT NULL
          )
        ''');
      },
    );
    _loadRecords();
  }

  // READ & SEARCH Operations
  Future<void> _loadRecords() async {
    if (_db == null) return;
    setState(() => _isLoading = true);

    List<Map<String, dynamic>> results;
    if (_searchController.text.isEmpty) {
      results = await _db!.query('records', orderBy: 'id DESC');
    } else {
      results = await _db!.query(
        'records',
        where: 'attendeeName LIKE ?',
        whereArgs: ['%${_searchController.text.trim()}%'],
      );
    }

    setState(() {
      _savedBookings = results.map((json) => InlineTicketBooking.fromMap(json)).toList();
      _isLoading = false;
    });
  }

  // CREATE Operation
  void _confirmPurchase() async {
    if (_formKey.currentState!.validate() && _db != null) {
      final newBooking = InlineTicketBooking(
        attendeeName: _nameController.text.trim(),
        ticketCount: int.parse(_ticketController.text.trim()),
        eventTitle: widget.eventTitle,
      );

      await _db!.insert('records', newBooking.toMap());
      _nameController.clear();
      _ticketController.text = '1';

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ticket saved to local SQLite database!')),
      );
      _loadRecords();
    }
  }

  // DELETE Operation
  void _deleteRecord(int id) async {
    if (_db != null) {
      await _db!.delete('records', where: 'id = ?', whereArgs: [id]);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking removed from storage.')),
      );
      _loadRecords();
    }
  }

  // UPDATE Operation
  void _showEditDialog(InlineTicketBooking booking) {
    final nameEdit = TextEditingController(text: booking.attendeeName);
    final qtyEdit = TextEditingController(text: booking.ticketCount.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2C),
        title: const Text('Update Ticket Record', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameEdit,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Attendee Name'),
            ),
            TextField(
              controller: qtyEdit,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Tickets'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (_db != null) {
                await _db!.update(
                  'records',
                  {
                    'attendeeName': nameEdit.text.trim(),
                    'ticketCount': int.parse(qtyEdit.text.trim()),
                  },
                  where: 'id = ?',
                  whereArgs: [booking.id],
                );
                if (!mounted) return;
                Navigator.pop(context);
                _loadRecords();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ticketController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Booking & Local Records'),
      ),
      body: Column(
        children: [
          // 1. Input Form Layer
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Booking for: ${widget.eventTitle}', style: const TextStyle(fontSize: 16, color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: 'Full Name', filled: true, fillColor: Color(0xFF2C2C2C)),
                    validator: (value) => value == null || value.trim().isEmpty ? 'Please enter name' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _ticketController,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Number of Tickets', filled: true, fillColor: Color(0xFF2C2C2C)),
                    validator: (value) => value == null || value.isEmpty ? 'Specify quantity' : null,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _confirmPurchase,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                    child: const Text('Confirm Purchase (Save Local)', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
          const Divider(color: Colors.grey),

          // 2. Search Field Area
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _loadRecords(),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Search database entries by name...',
                prefixIcon: Icon(Icons.search, color: Colors.deepPurpleAccent),
                filled: true,
                fillColor: Color(0xFF1E1E1E),
              ),
            ),
          ),

          // 3. Built-in SQLite View List (Displays results dynamic update/delete actions)
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _savedBookings.isEmpty
                ? const Center(child: Text('No local record items found.', style: TextStyle(color: Colors.grey)))
                : ListView.builder(
              itemCount: _savedBookings.length,
              itemBuilder: (context, index) {
                final item = _savedBookings[index];
                return Card(
                  color: const Color(0xFF2C2C2C),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    title: Text(item.eventTitle, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    subtitle: Text('Name: ${item.attendeeName} | Qty: ${item.ticketCount}', style: const TextStyle(color: Colors.grey)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showEditDialog(item)),
                        IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteRecord(item.id!)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}