import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../services/api_service.dart';

class EventProvider extends ChangeNotifier {
  List<EventModel> _events = [];
  bool _isLoading = false;

  List<EventModel> get events => _events;
  bool get isLoading => _isLoading;

  final ApiService _apiService = ApiService();

  Future<void> fetchEvents() async {
    _isLoading = true;
    notifyListeners(); // Tells the UI to show the loading spinner

    _events = await _apiService.fetchEvents();

    _isLoading = false;
    notifyListeners(); // Tells the UI to rebuild with the new data
  }
}