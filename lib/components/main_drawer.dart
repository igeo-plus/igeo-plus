import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  Widget _createDrawerItem(IconData icon, String label, Function onTap) {
    return ListTile(
      leading: Icon(
        icon,
        color: Color.fromARGB(255, 7, 163, 221),
      ),
      title: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          AppBar(
            title: Text("Configurações"),
            automaticallyImplyLeading: false,
          ),
          _createDrawerItem(Icons.person, "Editar conta", () => {}),
          _createDrawerItem(Icons.logout, "Logout", () => {})
        ],
      ),
    );
  }
}
