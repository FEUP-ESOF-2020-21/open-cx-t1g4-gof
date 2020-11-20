import 'package:flutter/material.dart';
import 'package:inquirescape/firebase/FirebaseController.dart';
import 'package:inquirescape/model/Question.dart';
import 'package:inquirescape/widgets/QuestionCard.dart';

class QuestionListPage extends StatefulWidget {
  final FirebaseController _fbController;
  final Widget _drawer;

  QuestionListPage(this._fbController, this._drawer);

  @override
  State<StatefulWidget> createState() {
    return QuestionListPageState();
  }
}

class QuestionListPageState extends State<QuestionListPage> {

  @override
  void initState() {
    this.widget._fbController.reloadQuestions((arg) { setState(() {}); });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    List<Question> questions = this.widget._fbController.conferenceQuestions;

    return SafeArea(
      child: RefreshIndicator(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Questions Page"),
            centerTitle: true,
          ),
          drawer: this.widget._drawer,
          body: questions == null ? _questionsUnloaded(context) : _questionList(context, questions),
        ),
        onRefresh: this._onRefresh,
      ),
    );
  }

  Widget _questionsUnloaded(BuildContext context) {
    return Center(child: Text("No questions D:", style: TextStyle(color: Colors.grey, fontSize: 22),),);
  }

  Future<void> _onRefresh() async {
    this.setState(() {});
    print("I feel rather refreshed");
  }

  Widget _questionList(BuildContext context, List<Question> questions) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: questions.length,
      itemBuilder: (BuildContext context, int index) {
        return QuestionCard(
          question: questions[index],
          questionIndex: index,
          // onClick: goToFullQuestionTab,
        );
      },
    );
  }
}
