import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:inquirescape/Question.dart';
import 'package:inquirescape/pages/QuestionFullPage.dart';

class QuestionCard extends StatelessWidget {
  final Question question;
  // final Function onClick;

  QuestionCard({Key key, @required this.question}) : super(key: key);

  onClick(BuildContext ctx) {
    Navigator.push(ctx,
        MaterialPageRoute(builder: (ctx) => QuestionFullPage(this.question)));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          if (onClick != null) {
            onClick(context);
          }
        },
        child: ListTile(
            // leading: const Icon(Icons.announcement_rounded),
            title: Text(question.userName),
            subtitle: Text(question.description,
                overflow: TextOverflow.ellipsis, maxLines: 3)),
      ),
    );
  }
}
