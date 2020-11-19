import 'package:flutter/material.dart';

class DrawerEntry extends StatelessWidget {
  final IconData icon;
  final String text, path;

  DrawerEntry(this.icon, this.text, this.path);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(this.icon),
      title: Text(this.text),
      onTap: () {
        Navigator.pushReplacementNamed(context, this.path);
      },
    );
  }
}

class InquireScapeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'A Header for later',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          DrawerEntry(Icons.person, "Login", "/login"),
          Divider(),
          DrawerEntry(Icons.notes_rounded, "Questions", "/questions"),
        ],
      ),
    );
  }
}
