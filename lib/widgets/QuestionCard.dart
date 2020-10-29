import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:inquirescape/Question.dart';

class QuestionCard extends StatefulWidget {
  final Question question;
  final Function onClick;

  QuestionCard({Key key, @required this.question, this.onClick}) : super(key: key);

  @override
  _QuestionCardState createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          if (widget.onClick != null) {
            widget.onClick(widget.question);
          }
        },
        child: ListTile(
            leading: const Icon(Icons.announcement_rounded),
            title: Text(widget.question.userName),
            subtitle: Text(widget.question.description,
                overflow: TextOverflow.ellipsis, maxLines: 3)),
      ),
    );
  }
}
