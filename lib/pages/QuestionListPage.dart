import 'package:flutter/material.dart';
import 'package:inquirescape/widgets/InquireScapeDrawer.dart';
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
    return RefreshIndicator(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Questions Page"),
          centerTitle: true,
        ),
        drawer: InquireScapeDrawer(),
        body: _questionList(context),
      ),
      onRefresh: this._onRefresh,
    );
  }

  Future<void> _onRefresh() async {
    this.setState(() {});
    print("I feel rather refreshed");
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
      },
    );
  }
}
