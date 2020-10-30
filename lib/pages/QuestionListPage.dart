import 'package:flutter/material.dart';
import 'package:inquirescape/Question.dart';
import 'package:inquirescape/widgets/QuestionCard.dart';

class QuestionListPage extends StatelessWidget {

  final Function goToFullQuestionTab;

  final List<Question> questions = [Question.sampleQuestion(1), Question.sampleQuestion(3), Question.sampleQuestion(2), Question.sampleQuestion(0), Question.sampleQuestion(1), Question.sampleQuestion(0), Question.sampleQuestion(2), Question.sampleQuestion(3)];

  QuestionListPage({this.goToFullQuestionTab});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: 8,
            itemBuilder: (BuildContext context, int index) {
              return QuestionCard(question: questions[index], onClick: goToFullQuestionTab,);
            });
  }
}
