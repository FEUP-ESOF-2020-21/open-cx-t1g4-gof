import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inquirescape/firebase/FirebaseController.dart';
import 'package:inquirescape/model/Moderator.dart';
import 'package:inquirescape/themes/MyTheme.dart';

class ProfilePage extends StatelessWidget {
  final Moderator mod = FirebaseController.currentMod;

  @override
  Widget build(BuildContext context) {
    String title = mod.username + (mod.username.endsWith('s') ? "' Profile" : "'s Profile");
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    const TextStyle headerStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
    const TextStyle infoStyle = TextStyle(fontSize: 18);

    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        Positioned(
          top: 75,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 300, minWidth: 320),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Padding(
                padding: EdgeInsets.only(left: 20, top: 60, right: 20, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Username:", style: headerStyle),
                    Text(mod.username, style: infoStyle),
                    Divider(color: Colors.transparent, height: 20),
                    Text("Email:", style: headerStyle),
                    Text(mod.email, style: infoStyle),
                    Divider(height: 20),
                    Text("Talks moderated:", style: headerStyle),
                    Text(FirebaseController.myConferences.length.toString(), style: infoStyle),
                    Divider(color: Colors.transparent, height: 20),
                    Text("Average question rating:", style: headerStyle),
                    Text("4.2", style: infoStyle),
                    Divider(color: Colors.transparent, height: 20),
                    Text("Total questions rated:", style: headerStyle),
                    Text("12", style: infoStyle),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 25,
          child: CircleAvatar(
            radius: 50,
            backgroundColor: MyTheme.theme.primaryColor,
            child: Text(
              mod.username[0],
              style: TextStyle(fontSize: 50, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
