import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:inquirescape/Question.dart';
import 'package:inquirescape/pages/QuestionFullPage.dart';

import 'QuestionsHolder.dart';

class QuestionCard extends StatelessWidget {
  final Question question;
  final int questionIndex;

  QuestionCard({Key key, @required this.question,  @required this.questionIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () async {
          Navigator.push(context, MaterialPageRoute(builder: (context) => QuestionFullPage(this.question))).then((value) => QuestionsHolder.of(context).update());
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
