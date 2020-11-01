import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:inquirescape/Question.dart';
import 'package:inquirescape/widgets/QuestionCard.dart';

class QuestionListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return QuestionListPageState();
  }
}

class QuestionListPageState extends State<QuestionListPage> {
  // final Function goToFullQuestionTab;

  final List<Question> questions = [
    Question.sampleQuestion(1),
    Question.sampleQuestion(3),
    Question.sampleQuestion(2),
    Question.sampleQuestion(0),
    Question.sampleQuestion(1),
    Question.sampleQuestion(0),
    Question.sampleQuestion(2),
    Question.sampleQuestion(3)
  ];

  // QuestionListPage({this.goToFullQuestionTab});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Questions Page"),
      ),
      body: _questionList(),
    );
  }

  Widget _questionList() {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: 8,
        itemBuilder: (BuildContext context, int index) {
          return QuestionCard(
            question: questions[index],
            // onClick: goToFullQuestionTab,
          );
        });
  }
}
