import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

import '../models/point.dart';
import '../models/subject.dart';

import '../utils/routes.dart';

class PointItem extends StatelessWidget {
  final List<Point> points;
  const PointItem(this.points);

  void _goToPointDetailsScreen(
      BuildContext context, Subject subject, Point point) {
    Navigator.of(context).pushNamed(AppRoutes.POINT_DETAIL,
        arguments: {"subject": subject, "point": point});
  }

  @override
  Widget build(BuildContext context) {
    final subject = ModalRoute.of(context)!.settings.arguments as Subject;
    return ListView.builder(
      itemCount: points.length,
      itemBuilder: (ctx, index) {
        return Column(
          children: [
            InkWell(
              onTap: () =>
                  _goToPointDetailsScreen(context, subject, points[index]),
              splashColor: Colors.amber,
              hoverColor: Color.fromARGB(255, 181, 220, 238),
              child: ListTile(
                leading: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: CircleAvatar(
                    child: Text(
                      "${index}",
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    backgroundColor: Colors.grey,
                  ),
                ),
                title: Text(points[index].name!),
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
                        "Lat: ${points[index].lat} - Long: ${points[index].long}"),
                  ],
                ),
              ),
            ),
            Divider(),
          ],
        );
      },
    );
  }
}
