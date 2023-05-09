import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  Widget _createDrawerItem(IconData icon, String label, Function onTap) {
    return TextButton(
      child: ListTile(
        leading: Icon(icon, color: Color.fromARGB(255, 7, 163, 221)),
        title: Text(label),
      ),
      onPressed: () => onTap(),
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
          //_createDrawerItem(Icons.person, "Editar conta", () => print("ok")),
          _createDrawerItem(Icons.logout, "Sair", () => SystemNavigator.pop())
        ],
      ),
    );
  }
}
