import 'package:flutter/material.dart';
import 'booking_form_screen.dart';

class EventDetailsScreen extends StatelessWidget {
  final Map<String, String> vibe;
  const EventDetailsScreen({super.key, required this.vibe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text(vibe['name']!), backgroundColor: Colors.black),
      body: Column(
        children: [
          Image.network(vibe['img']!, height: 250, width: double.infinity, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Day: ${vibe['day']}", style: const TextStyle(color: Colors.white, fontSize: 18)),
                Text("Time: ${vibe['time']}", style: const TextStyle(color: Colors.white, fontSize: 18)),
                Text("Place: ${vibe['place']}", style: const TextStyle(color: Colors.white, fontSize: 18)),
                Text("Price: \$${vibe['price']}", style: const TextStyle(color: Colors.white, fontSize: 18)),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => BookingFormScreen(eventTitle: vibe['name']!)));
                    },
                    child: const Text("Book Now"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}