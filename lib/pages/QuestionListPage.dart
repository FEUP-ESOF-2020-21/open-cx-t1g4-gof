import 'package:flutter/material.dart';
import 'package:inquirescape/widgets/QuestionCard.dart';
import 'package:inquirescape/widgets/QuestionsHolder.dart';

class QuestionListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return QuestionListPageState();
  }
}

class QuestionListPageState extends State<QuestionListPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Questions Page"),
        centerTitle: true,
      ),
      body: _questionList(context),
    );
  }

  Widget _questionList(BuildContext context) {
    QuestionsHolderState questionsHolder = QuestionsHolder.of(context);

    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: questionsHolder.questions.numQuestions,
        itemBuilder: (BuildContext context, int index) {
          return QuestionCard(
            question: questionsHolder.questions.getQuestion(index),
            questionIndex: index,
            // onClick: goToFullQuestionTab,
          );
        });
  }
}
