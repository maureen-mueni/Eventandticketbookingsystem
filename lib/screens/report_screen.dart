import 'package:flutter/material.dart';
import '../services/database_helper.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});
  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {

  // Method to calculate total
  double calculateTotal(List<Map<String, dynamic>> bookings) {
    double total = 0;
    for (var b in bookings) {
      total += double.tryParse(b['price'].toString()) ?? 0;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("Booking Records"), backgroundColor: Colors.black),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper.instance.getBookings(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final bookings = snapshot.data!;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Total Spent: \$${calculateTotal(bookings)}",
                    style: const TextStyle(color: Colors.green, fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (ctx, i) => Card(
                    color: Colors.white10,
                    child: ListTile(
                      title: Text(bookings[i]['event'], style: const TextStyle(color: Colors.white)),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await DatabaseHelper.instance.deleteBooking(bookings[i]['id']);
                          setState(() {}); // Refreshes the screen
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}