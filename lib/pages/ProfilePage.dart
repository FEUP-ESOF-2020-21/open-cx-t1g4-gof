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
    return Padding(
      padding: EdgeInsets.all(5),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(flex: 1),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: MyTheme.theme.primaryColor,
                      child: Text(mod.username[0]),
                    ),
                    Text(mod.username),
                    Text(mod.email),
                  ],
                ),
              ),
            ),
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
