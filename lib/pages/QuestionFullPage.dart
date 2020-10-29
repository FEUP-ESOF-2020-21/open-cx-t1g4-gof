import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inquirescape/Question.dart';

class QuestionFullPage extends StatelessWidget {
  final Question question;

  QuestionFullPage(this.question);

  @override
  Widget build(BuildContext context) {
    if (question != null)
      return Container(
          padding:
              EdgeInsetsDirectional.only(start: 8, top: 8, end: 8, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsetsDirectional.only(top: 2, bottom: 8),
                  child: Text(
                    question.userName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )),
              Text(question.description, style: TextStyle(fontSize: 16)),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.contain, // otherwise the logo will be tiny
                  child: const FlutterLogo(),
                ),
              ),
            ],
          ));
    else
      return Align(
        alignment: Alignment.center,
        child: Text(
          "No question focused",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      );
  }
}
