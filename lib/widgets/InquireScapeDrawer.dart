import 'package:flutter/material.dart';
import 'package:inquirescape/firebase/FirebaseController.dart';
import 'package:inquirescape/firebase/FirebaseListener.dart';
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
  final FirebaseController _fbController;

  InquireScapeDrawer(this._fbController);

  @override
  _InquireScapeDrawerState createState() => _InquireScapeDrawerState();
}

class _InquireScapeDrawerState extends State<InquireScapeDrawer> implements FirebaseListener {
  bool loggedIn = false;
  Moderator mod;

  @override
  void initState() {
    super.initState();

    this.widget._fbController.subscribeListener(this);

    this.updateState();
  }

  Future<void> updateState() async {
    return await this.widget._fbController.isLoggedIn().then((bool value) {
      setState(() {
        this.loggedIn = value;
        this.mod = this.widget._fbController.currentMod;
      });
    });
  }

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
          _DrawerEntry(Icons.mic, "Conference", "/login"),
          _DrawerEntry(Icons.notes_rounded, "Questions", "/questions"),
        ],
      ),
    );
  }

  @override
  void onLoginIncorrect() { }

  @override
  void onLoginSuccess() {
    if (mounted)
      setState(() {
        this.loggedIn = true;
        this.mod = this.widget._fbController.currentMod;
      });
  }

  @override
  void onRegisterDuplicate() { }

  @override
  void onRegisterSuccess() { }

  @override
  void onDataChanged() { }

  @override
  void onLogout() {
    if (mounted)
      setState(() {
        this.loggedIn = true;
        this.mod = this.widget._fbController.currentMod;
      });
  }
}
