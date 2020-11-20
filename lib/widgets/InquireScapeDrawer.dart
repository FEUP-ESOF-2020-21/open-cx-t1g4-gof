import 'package:flutter/material.dart';
import 'package:inquirescape/model/Moderator.dart';

// ---------------
//     ENTRY
// ---------------
class _DrawerEntry extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function() onTap;

  _DrawerEntry(this.icon, this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(this.icon),
      title: Text(
        this.text,
        style: TextStyle(
          fontSize: 22,
          color: Colors.black54,
        ),
      ),
      onTap: this.onTap,
    );
  }
}

// ---------------
//     DRAWER
// ---------------
class InquireScapeDrawer extends StatefulWidget {
  @override
  _InquireScapeDrawerState createState() => _InquireScapeDrawerState();
}

class _InquireScapeDrawerState extends State<InquireScapeDrawer> {

  static bool _expanded = false;

  // TEMP
  bool loggedIn = true;
  Moderator mod = Moderator.withoutRef("aaguiar", "aaguiar@fe.up.pt", "Ademar Aguiar");


  @override
  Widget build(BuildContext context) {
    return this.loggedIn ? this.buildLoggedIn(context) : this.buildLoggedOff(context);
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
          _DrawerEntry(Icons.login, "Log In", () => Navigator.pushReplacementNamed(context, "/login")),
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
                    // shadows: [Shadow(offset: Offset(-2, -2), blurRadius: 10)],
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
                      this.mod.username,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                      overflow: TextOverflow.clip,
                      maxLines: 2,
                    ),
                    Text(
                      this.mod.email,
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
          _DrawerEntry(Icons.home, "Home", () => Navigator.pushReplacementNamed(context, "/")),
          ExpansionTile(
            initiallyExpanded: _InquireScapeDrawerState._expanded,
            onExpansionChanged: (value) => _InquireScapeDrawerState._expanded = value,
            title: _DrawerEntry(Icons.mic, "Conference", null),
            children: [
              _DrawerEntry(Icons.subdirectory_arrow_right_rounded, "Current", () => Navigator.pushReplacementNamed(context, "/conference/current")),
              _DrawerEntry(Icons.hourglass_empty_rounded, "Questions", () => Navigator.pushReplacementNamed(context, "/conference/questions")),
              _DrawerEntry(Icons.note, "Post Question", () => Navigator.pushReplacementNamed(context, "/conference/postQuestion")),
              _DrawerEntry(Icons.format_list_bulleted, "My Conferences", () => Navigator.pushReplacementNamed(context, "/conference/myConferences")),
              _DrawerEntry(Icons.insert_invitation, "Invites", () => Navigator.pushReplacementNamed(context, "/conference/invites")),
              _DrawerEntry(Icons.add_box_outlined, "Create New", () => Navigator.pushReplacementNamed(context, "/conference/create")),
            ],
          ),
          _DrawerEntry(Icons.account_circle_rounded, "Profile", () => Navigator.pushReplacementNamed(context, "/profile")),
          _DrawerEntry(Icons.logout, "Log Out", () => print("Dunno what to do :upside_down:")),
        ],
      ),
    );
  }
}
