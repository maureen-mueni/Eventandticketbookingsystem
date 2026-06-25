// File: lib/services/event_theme.dart
import 'package:flutter/material.dart';

class EventTheme {
  static Map<String, dynamic> getTheme(String category) {
    switch (category.toLowerCase()) {
      case 'beach':
        return {
          'color': Colors.blueAccent,
          'image': 'assets/beach.jpg',
        };
      case 'art':
        return {
          'color': Colors.purple,
          'image': 'assets/art.jpg',
        };
      default:
        return {
          'color': Colors.grey,
          'image': 'assets/default.jpg',
        };
    }
  }
}