import 'package:flutter/material.dart';

import '../models/point.dart';
import '../models/subject.dart';

import '../utils/routes.dart';

class PointItem extends StatelessWidget {
  final Point point;
  final void Function(int) onDeletePoint;
  final void Function(int, int) onToggleFavorite;
  const PointItem(this.point, this.onDeletePoint, this.onToggleFavorite,
      {super.key});

  void _goToPointDetailsScreen(
      BuildContext context, Subject subject, Point point) {
    Navigator.of(context).pushNamed(AppRoutes.POINT_DETAIL,
        arguments: {"subject": subject, "point": point});
  }

  @override
  Widget build(BuildContext context) {
    final subject = ModalRoute.of(context)!.settings.arguments as Subject;
    return InkWell(
      onTap: () => _goToPointDetailsScreen(context, subject, point),
      splashColor: Colors.amber,
      hoverColor: Color.fromARGB(255, 181, 220, 238),
      child: Dismissible(
        key: ValueKey(point.id),
        onDismissed: (_) {
          onDeletePoint(point.id!);
        },
        direction: DismissDirection.endToStart,
        background: Container(
          color: Theme.of(context).errorColor,
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 30,
          ),
          padding: const EdgeInsets.only(right: 20),
          alignment: Alignment.centerRight,
        ),
        child: ListTile(
          leading: FittedBox(
            fit: BoxFit.fitWidth,
            child: CircleAvatar(
              // child: Text(
              //   "${point.id}",
              //   style: TextStyle(fontSize: 12, color: Colors.white),
              // ),
              child: Icon(
                Icons.gps_fixed_outlined,
                color: Colors.white,
              ),
              backgroundColor: Colors.grey,
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
          trailing: IconButton(
            icon: point.isFavorite == true
                ? Icon(
                    Icons.star,
                    color: Colors.amber,
                  )
                : Icon(
                    Icons.star_outline,
                    color: Colors.amber,
                  ),
            onPressed: () {
              onToggleFavorite(point.id!, subject.id);
            },
          ),
        ),
      ),
    );
  }
}
