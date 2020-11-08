import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inquirescape/Question.dart';
import 'package:inquirescape/pages/EditQuestionPage.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class QuestionFullPage extends StatefulWidget {
  final Question _question;

  QuestionFullPage(this._question);

  @override
  _QuestionFullPageState createState() => _QuestionFullPageState();
}

class _QuestionFullPageState extends State<QuestionFullPage> {
  @override
  Widget build(BuildContext context) {
    if (widget._question != null)
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget._question.userName),
            centerTitle: true,
          ),
          body: Container(
            padding:
                EdgeInsetsDirectional.only(start: 8, top: 8, end: 8, bottom: 8),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget._question.description,
                    style: TextStyle(fontSize: 20),
                    maxLines: null,
                  ),
                ],
              ),
            ),
          ),
          persistentFooterButtons: [ratingBar(context), editButton(context)],
        ),
      );
  }

  Widget ratingBar(BuildContext context) {
    return RatingBarIndicator(
      rating: widget._question.rating,
      itemBuilder: (context, index) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      itemCount: 5,
      itemSize: 30.0,
      unratedColor: Colors.amber.withAlpha(50),
      direction: Axis.horizontal,
    );
  }

  Widget editButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.edit),
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      onPressed: () => {
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) => EditQuestionPage(widget._question)))
            .then((value) => {this.setState(() {})}),
      },
    );
  }
}
