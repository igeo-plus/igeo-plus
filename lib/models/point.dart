import 'package:flutter/widgets.dart';
import 'dart:io';

class Point with ChangeNotifier {
  String? id;
  String? name;
  double? lat;
  double? long;
  String? date;
  String? time;
  String? description;
  String? user_id;
  String? subject_id;
  bool isFavorite;
  List<String> image = [];
  List<String>? pickedImages = [];

  Point({
    this.id,
    this.name,
    this.lat,
    this.long,
    this.date,
    this.time,
    this.description,
    this.user_id,
    this.subject_id,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      "lat": lat,
      "long": long,
      "date": date,
      "time": time,
      "description": description,
      "user_id": user_id,
      "subject_id": subject_id,
      "isFavorite": isFavorite = false,
    };
  }

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  void addUrlToImageList(String url) {
    image.add(url);
  }

  void changeCoordinates(double lat, double long) {
    this.lat = lat;
    this.long = long;
    notifyListeners();
  }
}
