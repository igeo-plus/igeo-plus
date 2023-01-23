import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/point_list.dart';
import '../models/subject.dart';

import '../components/point_item_favorite.dart';

class FavoriteScreen extends StatefulWidget {
  final List<Subject> subjects;
  const FavoriteScreen(this.subjects, {super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    final pointList = Provider.of<PointList>(context).favoritePoints;
    return Scaffold(
      body: ListView.builder(
        itemCount: pointList.length,
        itemBuilder: (ctx, index) {
          return Column(
            children: [
              PointItemFavorite(
                pointList[index],
                widget.subjects,
              ),
            ],
          );
        },
      ),
    );
  }
}
