import 'package:flutter/material.dart';
import 'package:inquirescape/firebase/FirebaseController.dart';

class InquireScapeHome extends StatelessWidget {
  final FirebaseController _fbController;
  final Widget _drawer;

  InquireScapeHome(this._fbController, this._drawer);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("InquireScape"),
        centerTitle: true,
      ),
      drawer: this._drawer,
      body: Center(child: Text("Hello there, general Kenobi")),
    ));
  }
}
