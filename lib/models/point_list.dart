import 'package:flutter/widgets.dart';

import '../models/point.dart';

List<Point> dummyPoints = [
  Point(
    id: 1,
    name: "Teste 1",
    lat: -22,
    long: -43,
    date: DateTime.now().toString(),
    time: DateTime.now().toString(),
    description: "bla bla bla",
    subject_id: 1,
    user_id: 1,
  ),
  Point(
    id: 2,
    name: "Teste 2",
    lat: -22,
    long: -43,
    date: DateTime.now().toString(),
    time: DateTime.now().toString(),
    description: "bla bla bla",
    subject_id: 1,
    user_id: 1,
  ),
  Point(
    id: 1,
    name: "Teste 3",
    lat: -22,
    long: -43,
    date: DateTime.now().toString(),
    time: DateTime.now().toString(),
    description: "bla bla bla",
    subject_id: 2,
    user_id: 1,
  ),
];

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
  }

  void clear() {
    points = [];
    notifyListeners();
  }

  void getPointsFromDB() {
    for (var point in dummyPoints) {
      points.add(point);
    }
    notifyListeners();
  }
}
