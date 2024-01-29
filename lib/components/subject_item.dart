import 'package:flutter/material.dart';
import 'package:igeo_flutter/screens/subject_points_screen.dart';

import '../models/subject.dart';
import '../utils/routes.dart';

//const String IMAGE_URL =
//"https://plus.unsplash.com/premium_photo-1661963174486-3c967378b1b8?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=871&q=80";

class SubjectItem extends StatelessWidget {
  final Subject subject;
  //final Map<String, dynamic> userData;
  //final Function(int, String, int) onDeleteSubject;
  final Function(String) onDeleteSubject;

  const SubjectItem(this.subject, this.onDeleteSubject, {super.key});

  void _selectSubject(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => SubjectPointsScreen(subject)));
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.horizontal,
      background: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          color: Theme.of(context).colorScheme.error,
          padding: const EdgeInsets.only(right: 20),
          alignment: Alignment.centerRight,
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
      key: ValueKey(subject.id),
      onDismissed: (_) {
        onDeleteSubject(subject.id);
      },
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: InkWell(
          splashColor: Colors.amber,
          hoverColor: const Color.fromARGB(255, 181, 220, 238),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
          onTap: () => _selectSubject(context),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            elevation: 4,
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      child: Image.asset(
                        "assets/images/subject_item_image.png",
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      right: 0,
                      child: Container(
                        width: 180,
                        color: Colors.black54,
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 20,
                        ),
                        child: Text(
                          subject.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
