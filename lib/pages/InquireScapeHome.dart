import 'package:flutter/material.dart';

import 'package:inquirescape/widgets/InquireScapeDrawer.dart';

class InquireScapeHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("InquireScape"),
            centerTitle: true,
          ),
          drawer: InquireScapeDrawer(),
          body: Center(child: Text("Hello there, general Kenobi"))),
    );
  }
}
