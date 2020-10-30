import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inquirescape/pages/QuestionListPage.dart';
import 'package:inquirescape/pages/QuestionFullPage.dart';
import 'package:inquirescape/Question.dart';

class TabbedPage extends StatefulWidget {

  @override
  _TabbedPageState createState() => _TabbedPageState();
}

class _TabbedPageState extends State<TabbedPage>
    with SingleTickerProviderStateMixin {

  Question _question;
  TabController _controller;

  void goToFullQuestionTab(Question question) {
    this.setState(() {
      _question = question;
    });
    Timer(Duration(milliseconds: 20), tmp);
  }

  void tmp() {
    _controller.animateTo(1);
  }

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _controller,
        children: <Widget>[
          QuestionListPage(
            goToFullQuestionTab: goToFullQuestionTab,
          ),
          QuestionFullPage(_question),
        ],
      ),
      bottomNavigationBar: Material(
        color: Theme.of(context).colorScheme.primary,
        child: TabBar(
            labelPadding: EdgeInsetsDirectional.only(top: 4, bottom: 4),
            controller: _controller,
            tabs: const <Widget>[
              Icon(Icons.view_list_rounded),
              Icon(Icons.border_color),
              // Tab(icon: Icon(Icons.view_list_rounded), child: Text('List')),
              // Tab(icon: Icon(Icons.border_color), child: Text('Details'))
            ]),
      ),
    );
  }
}
