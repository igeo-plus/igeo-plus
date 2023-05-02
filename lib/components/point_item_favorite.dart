import 'package:flutter/material.dart';

import '../models/point.dart';
import '../models/subject.dart';

import '../utils/routes.dart';

class PointItemFavorite extends StatelessWidget {
  final Point point;
  final List<Subject> subjects;

  const PointItemFavorite(this.point, this.subjects, {super.key});

  void _goToPointDetailsScreen(
      BuildContext context, List<Subject> subjects, Point point) {
    Subject subject =
        subjects.where((subject) => subject.id == point.subject_id).first;
    Navigator.of(context).pushNamed(AppRoutes.POINT_DETAIL,
        arguments: {"subject": subject, "point": point});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _goToPointDetailsScreen(context, subjects, point),
      splashColor: Colors.amber,
      hoverColor: Color.fromARGB(255, 181, 220, 238),
      child: ListTile(
        leading: FittedBox(
          fit: BoxFit.fitWidth,
          child: CircleAvatar(
            child: Icon(
              Icons.star_border_outlined,
              color: Colors.amber,
            ),
            //backgroundColor: Colors.grey,
          ),
        ),
        title: Text(point.name!),
        subtitle: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 2),
              child: Icon(
                Icons.gps_fixed_sharp,
                size: 13,
                color: Color.fromARGB(255, 7, 163, 221),
              ),
            ),
            Text(
                "Lat: ${point.lat!.toStringAsFixed(2)} - Long: ${point.long!.toStringAsFixed(2)}"),
          ],
        ),
      ),
    );
  }
}
