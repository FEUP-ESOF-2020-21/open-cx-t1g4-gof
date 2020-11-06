import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inquirescape/Question.dart';
import 'package:inquirescape/pages/EditQuestionPage.dart';

class QuestionFullPage extends StatefulWidget {
  final Question _question;
  QuestionFullPage(this._question);

  @override
  _QuestionFullPageState createState() => _QuestionFullPageState();
}

class _QuestionFullPageState extends State<QuestionFullPage> {
  @override
  Widget build(BuildContext context) {
    if (widget._question != null)
      return Scaffold(
        appBar: AppBar(
          title: Text(widget._question.userName),
          centerTitle: true,
        ),
        body: Container(
            padding:
                EdgeInsetsDirectional.only(start: 8, top: 8, end: 8, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(widget._question.description,
                    style: TextStyle(fontSize: 20)),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.contain, // otherwise the logo will be tiny
                    child: const FlutterLogo(),
                  ),
                ),
              ],
            )),
        persistentFooterButtons: [editButton(context)],
      );
  }

  Widget editButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.edit),
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      onPressed: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => EditQuestionPage(widget._question))
        ).then((value) => {if (value) this.setState(() {})}),
      },
    );
  }
}
