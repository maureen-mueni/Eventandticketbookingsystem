import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'event_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _apiEvents = [];
  bool _isLoadingAPI = true;
  String _networkError = '';

  // Clean English titles to override the API's default Latin placeholder text
  final List<String> _englishEventTitles = [
    'NAIROBI TECH SUMMIT 2026',
    'MOMBASA JAZZ FESTIVAL',
    'AFRICA STARTUP PITCH',
    'GLOBAL BLOCKCHAIN EXPO',
    'LIVE MUSIC CONCERT',
  ];

  @override
  void initState() {
    super.initState();
    _fetchRESTApiRecords();
  }

  // Week 5 Core: Connects to a public REST API over the internet
  Future<void> _fetchRESTApiRecords() async {
    try {
      final url = Uri.parse('https://jsonplaceholder.typicode.com/posts?_limit=5');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> parsedJsonList = json.decode(response.body);

        setState(() {
          for (int i = 0; i < parsedJsonList.length; i++) {
            // We use the loop index to assign a beautiful English title to each incoming API item
            String cleanTitle = _englishEventTitles[i % _englishEventTitles.length];
            int itemId = parsedJsonList[i]['id'];

            _apiEvents.add({
              'title': cleanTitle,
              'date': 'Aug ${itemId + 12}',
              'location': 'Grand Hall, Zone $itemId',
              'image': 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=500',
            });
          }
          _isLoadingAPI = false;
        });
      } else {
        setState(() {
          _networkError = 'Server responded with status code: ${response.statusCode}';
          _isLoadingAPI = false;
        });
      }
    } catch (e) {
      setState(() {
        _networkError = 'Failed to connect to the API host network.';
        _isLoadingAPI = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Live Eventify Hub', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            Text('Connected securely to REST API endpoints', style: TextStyle(fontSize: 11, color: Colors.greenAccent)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search online event index...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.cloud_queue, color: Colors.deepPurpleAccent),
                filled: true,
                fillColor: const Color(0xFF2C2C2C),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 28),
            const Text('Dynamic API Stream Feed', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),

            if (_isLoadingAPI)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40.0),
                child: Center(child: CircularProgressIndicator(color: Colors.deepPurpleAccent)),
              )
            else if (_networkError.isNotEmpty)
              Center(child: Text(_networkError, style: const TextStyle(color: Colors.redAccent)))
            else
              SizedBox(
                height: 260,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _apiEvents.length,
                  itemBuilder: (context, index) {
                    final Map<String, String> event = Map<String, String>.from(_apiEvents[index]);
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EventDetailsScreen(event: event)),
                        );
                      },
                      child: Container(
                        width: 240,
                        margin: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                              child: Image.network(
                                event['image']!,
                                height: 130,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(event['title']!, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
                                  const SizedBox(height: 6),
                                  Row(children: [const Icon(Icons.calendar_month, size: 12, color: Colors.deepPurpleAccent), const SizedBox(width: 4), Text(event['date']!, style: const TextStyle(color: Colors.grey, fontSize: 11))]),
                                  const SizedBox(height: 4),
                                  Row(children: [const Icon(Icons.sensors, size: 12, color: Colors.green), const SizedBox(width: 4), Expanded(child: Text(event['location']!, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey, fontSize: 11)))]),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}