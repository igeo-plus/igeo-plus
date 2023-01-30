import 'package:flutter/widgets.dart';

import '../models/point.dart';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';

class PointList with ChangeNotifier {
  List<Point> points = [];

  List<Point> get getPoints => points;

  List<Point> getPointsForSubject(int subjectId) {
    return points.where((point) => point.subject_id == subjectId).toList();
  }

  List<Point> get favoritePoints =>
      points.where((point) => point.isFavorite).toList();

  void addPoint(Point point) {
    points.add(point);
    notifyListeners();
  }

  void removePoint(int id) {
    points.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Point getPoint(int pointId, int subjectId) {
    return points
        .where((point) => point.id == pointId && point.subject_id == subjectId)
        .first;
  }

  void togglePointFavorite(int pointId, int subjectId) {
    if (getPoint(pointId, subjectId).isFavorite == false) {
      getPoint(pointId, subjectId).isFavorite = true;
    } else {
      getPoint(pointId, subjectId).isFavorite = false;
    }
    notifyListeners();
    print(getPoint(pointId, subjectId).isFavorite);
  }

  void clear() {
    points = [];
    notifyListeners();
  }
}
