import 'package:flutter/material.dart';

import '../models/point.dart';
import '../models/subject.dart';

import '../utils/routes.dart';

class PointItem extends StatefulWidget {
  final List<Point> points;
  final void Function(int) onDeletePoint;
  const PointItem(this.points, this.onDeletePoint);

  @override
  State<PointItem> createState() => _PointItemState();
}

class _PointItemState extends State<PointItem> {
  void _goToPointDetailsScreen(
      BuildContext context, Subject subject, Point point) {
    Navigator.of(context).pushNamed(AppRoutes.POINT_DETAIL,
        arguments: {"subject": subject, "point": point});
  }

  @override
  Widget build(BuildContext context) {
    final subject = ModalRoute.of(context)!.settings.arguments as Subject;
    return ListView.builder(
      itemCount: widget.points.length,
      itemBuilder: (ctx, index) {
        return Column(
          children: [
            InkWell(
              onTap: () => _goToPointDetailsScreen(
                  context, subject, widget.points[index]),
              splashColor: Colors.amber,
              hoverColor: Color.fromARGB(255, 181, 220, 238),
              child: Dismissible(
                key: ValueKey(widget.points[index].id),
                onDismissed: (_) {
                  widget.onDeletePoint(widget.points[index].id!);
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
                      child: Text(
                        "${index}",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      backgroundColor: Colors.grey,
                    ),
                  ),
                  title: Text(widget.points[index].name!),
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
                          "Lat: ${widget.points[index].lat!.toStringAsFixed(2)} - Long: ${widget.points[index].long!.toStringAsFixed(2)}"),
                    ],
                  ),
                  trailing: IconButton(
                    icon: widget.points[index].isFavorite
                        ? Icon(
                            Icons.star,
                            color: Colors.amber,
                          )
                        : Icon(
                            Icons.star_outline,
                            color: Colors.amber,
                          ),
                    onPressed: () {
                      setState(() {
                        widget.points[index].toggleFavorite();
                      });
                    },
                  ),
                ),
              ),
            ),
            const Divider(),
          ],
        );
      },
    );
  }
}
