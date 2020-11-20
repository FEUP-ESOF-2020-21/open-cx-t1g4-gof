import 'package:flutter/material.dart';
import 'package:inquirescape/Question.dart';

class _QuestionsHolderInherited extends InheritedWidget {
  final QuestionsHolderState data;

  _QuestionsHolderInherited({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_QuestionsHolderInherited oldWidget) => true;
}

class QuestionsHolder extends StatefulWidget {
  QuestionsHolder({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  QuestionsHolderState createState() => new QuestionsHolderState();

  static QuestionsHolderState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<_QuestionsHolderInherited>()).data;
  }
}

class QuestionsHolderState extends State<QuestionsHolder> {
  /// List of Questions
  Questions questions = new Questions();

  void updateQuestion(int questionIndex, String newDescription) {
    setState(() {
      this.questions.getQuestion(questionIndex).description = newDescription;
    });
  }

  void update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new _QuestionsHolderInherited(
      data: this,
      child: widget.child,
    );
  }
}
