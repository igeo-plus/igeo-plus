import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class Point with ChangeNotifier {
  final int id;
  final String name;
  final double lat;
  final double long;
  final DateTime date;
  final DateTime time;
  final String description;
  final int user_id;
  final int subject_id;
  //final List<String> imageUrls;

  bool isFavorite = false;

  Point({
    required this.id,
    required this.name,
    required this.lat,
    required this.long,
    required this.date,
    required this.time,
    required this.description,
    required this.user_id,
    required this.subject_id,
    this.isFavorite = false,
  });

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
