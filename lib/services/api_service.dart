import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event_model.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  Future<List<EventModel>> fetchEvents() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      // We take the first 8 items from the internet to fit our clean English list
      List<dynamic> limitedBody = body.take(8).toList();
      return limitedBody.map((dynamic item) => EventModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load events from the network');
    }
  }
}