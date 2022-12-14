import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  Widget _createDrawerItem(IconData icon, String label, Function onTap) {
    return ListTile();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer();
  }
}
