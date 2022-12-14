import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  Widget _createDrawerItem(IconData icon, String label, Function onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            height: 55,
            width: double.infinity,
            child: Text(
              "Configurações",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          _createDrawerItem(Icons.person, "Editar conta", () => {}),
        ],
      ),
    );
  }
}
