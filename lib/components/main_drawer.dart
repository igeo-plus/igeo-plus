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
          Container(
            color: Color.fromARGB(255, 7, 163, 221),
            height: 55,
            width: double.infinity,
            child: Container(
              margin: EdgeInsets.only(
                left: 15,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.settings,
                    color: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      "Configurações",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _createDrawerItem(Icons.person, "Editar conta", () => {}),
        ],
      ),
    );
  }
}
