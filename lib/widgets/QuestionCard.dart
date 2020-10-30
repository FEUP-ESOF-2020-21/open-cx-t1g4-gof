import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:inquirescape/Question.dart';

class QuestionCard extends StatelessWidget {

  final Question question;
  final Function onClick;

  QuestionCard({Key key, @required this.question, this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          if (onClick != null) {
            onClick(question);
          }
        },
        child: ListTile(
            leading: const Icon(Icons.announcement_rounded),
            title: Text(question.userName),
            subtitle: Text(question.description,
                overflow: TextOverflow.ellipsis, maxLines: 3)),
      ),
    );
  }
}
