import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:inquirescape/config.dart';
import 'package:inquirescape/firebase/FirebaseController.dart';
import 'package:inquirescape/model/Moderator.dart';
import 'package:inquirescape/routes.dart';
import 'package:inquirescape/themes/MyTheme.dart';

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
        style: MyTheme.theme.textTheme.headline1,
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
  Moderator mod;

  @override
  void initState() {
    super.initState();

    currentTheme.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    mod = FirebaseController.currentMod;
    return Drawer(
      key: Key("inquireScapeDrawer"),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: MyTheme.theme.primaryColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Text(
                          'InquireScape',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
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
                            ),
                            Flexible(
                              flex: 1,
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: Image(image: AssetImage('assets/InquireScapeLogo.png')),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _DrawerEntry(Icons.account_circle_rounded, "Profile", () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, routeProfile);
                }),
                _DrawerEntry(Icons.logout, "Log Out", () {
                  Navigator.pop(context);
                  FirebaseController.logout();
                }),
                // Switch(value: MyAppState.light, onChanged: widget._appState.toggleTheme),
              ],
            ),
          ),
          Column(
            children: [
              _toggleTheme(),
              _DrawerEntry(Icons.settings, "Settings", () {
                Navigator.pop(context);
                Navigator.pushNamed(context, routeSettings);
              }),
              _DrawerEntry(Icons.help_outline, "About", () {
                Navigator.pop(context);
                Navigator.pushNamed(context, routeAbout);
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _toggleTheme() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(MyTheme.isDark ? "Dark Theme" : "Light Theme"),
          Switch(
            value: MyTheme.isLight,
            onChanged: currentTheme.switchTheme,
          ),
        ],
      ),
    );
  }
}
