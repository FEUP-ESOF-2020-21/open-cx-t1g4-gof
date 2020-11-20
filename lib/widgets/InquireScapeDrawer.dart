import 'package:flutter/material.dart';
import 'package:inquirescape/model/Moderator.dart';

// ---------------
//     ENTRY
// ---------------
class _DrawerEntry extends StatelessWidget {
  final IconData icon;
  final String text, path;

  _DrawerEntry(this.icon, this.text, this.path);

  @override
  Widget build(BuildContext context) {
    if (this.path != null) {
      return ListTile(
        leading: Icon(this.icon),
        title: Text(
          this.text,
          style: TextStyle(
            fontSize: 22,
            color: Colors.black54,
          ),
        ),
        onTap: () {
          Navigator.pushReplacementNamed(context, this.path);
        },
      );
    } else {
      return ListTile(
        leading: Icon(this.icon),
        title: Text(
          this.text,
          style: TextStyle(
            fontSize: 22,
            color: Colors.black54,
          ),
        ),
      );
    }
  }
}

// ---------------
//     DRAWER
// ---------------
class InquireScapeDrawer extends StatefulWidget {
  final bool loggedIn = true;
  final Moderator mod = Moderator.withoutRef("aaguiar", "aaguiar@fe.up.pt", "Ademar Aguiar");

  @override
  _InquireScapeDrawerState createState() => _InquireScapeDrawerState();
}

class _InquireScapeDrawerState extends State<InquireScapeDrawer> {
  @override
  Widget build(BuildContext context) {
    return this.widget.loggedIn ? this.buildLoggedIn(context) : this.buildLoggedOff(context);
  }

  Widget buildLoggedOff(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'InquireScape',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                  ),
                ),
                Text(
                  'Logged Off',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          _DrawerEntry(Icons.login, "Log In", "/login"),
        ],
      ),
    );
  }

  Widget buildLoggedIn(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'InquireScape',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Logged in as',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      this.widget.mod.username,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                      overflow: TextOverflow.clip,
                      maxLines: 2,
                    ),
                    Text(
                      this.widget.mod.email,
                      style: TextStyle(
                        color: Colors.grey[200],
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                )
              ],
            ),
          ),
          _DrawerEntry(Icons.mic, "Conference", "/login"),
          _DrawerEntry(Icons.notes_rounded, "Questions", "/questions"),
        ],
      ),
    );
  }
}
