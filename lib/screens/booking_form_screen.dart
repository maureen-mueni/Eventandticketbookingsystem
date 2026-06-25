import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import 'login_screen.dart';
import 'report_screen.dart';

class BookingFormScreen extends StatelessWidget {
  final String eventTitle;
  final TextEditingController qtyController = TextEditingController(text: "1");

  BookingFormScreen({super.key, required this.eventTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Booking: $eventTitle", style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: qtyController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Quantity",
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                // Prepare data for the database
                Map<String, dynamic> newBooking = {
                  'user': LoginScreen.nameController.text,
                  'event': eventTitle,
                  'count': qtyController.text,
                  'price': '50',
                };

                // Save to local SQLite database
                await DatabaseHelper.instance.addBooking(newBooking);

                // Navigate to the records screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const ReportScreen()),
                );
              },
              child: const Text("Confirm Booking"),
            ),
          ],
        ),
      ),
    );
  }
}