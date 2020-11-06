import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:inquirescape/Question.dart';
import 'package:inquirescape/pages/QuestionFullPage.dart';

import 'QuestionsHolder.dart';

class QuestionCard extends StatelessWidget {
  final Question question;
  final int questionIndex;

  QuestionCard({Key key, @required this.question, @required this.questionIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
      child: Card(
          child: Padding(
        padding: EdgeInsets.only(left: 4, top: 8, right: 4, bottom: 8),
        child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () async {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              QuestionFullPage(this.question)))
                  .then((value) => QuestionsHolder.of(context).update());
            },
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      question.userName,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Row(
                      children: [
                        Text(
                          question.rating.toStringAsFixed(1),
                          style: TextStyle(fontSize: 14),
                        ),
                        Icon(Icons.star, color: Colors.amber, size: 22),
                      ],
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                Text(
                  question.description,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(fontSize: 15),
                )
              ],
            )),
      )),
    );
  }
}
