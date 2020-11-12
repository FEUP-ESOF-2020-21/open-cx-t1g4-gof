import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inquirescape/firebase/FirebaseController.dart';

class LoginPage extends StatefulWidget {
  final FirebaseController _fbController;

  LoginPage(this._fbController);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Login"),
          centerTitle: true,
        ),
        body: Container(
          margin: EdgeInsetsDirectional.only(top: 10.0, bottom: 10.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.accessibility_sharp,
                  size: 200.0,
                ),
                Container(
                  margin: EdgeInsetsDirectional.only(
                      top: 20.0, start: 20.0, end: 20.0),
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.email),
                      hintText: 'Enter your email',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsetsDirectional.only(
                      top: 20.0, start: 20.0, end: 20.0),
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      icon: Icon(Icons.vpn_key),
                      hintText: 'Enter your password',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsetsDirectional.only(
                      top: 10.0, start: 20.0, end: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        child: Text("Create an account?"),
                        onPressed: () {},
                      ),
                      FlatButton(
                        child: Text("Forgot password?"),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                Container (
                  child: FlatButton(
                    child: Text("Sign In", style: TextStyle(fontSize: 20.0)),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
