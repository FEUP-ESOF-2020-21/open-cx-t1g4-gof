import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:inquirescape/firebase/FirebaseController.dart';
import 'package:inquirescape/model/Question.dart';
import 'package:inquirescape/pages/EditQuestionPage.dart';

import 'package:timeago/timeago.dart' as timeago;

class QuestionCard extends StatefulWidget {
  final Question question;
  final int questionIndex;
  final FirebaseController fbController;
  final void Function() onUpdate;

  QuestionCard(
      {Key key, @required this.question, @required this.questionIndex, @required this.fbController, this.onUpdate})
      : super(key: key);

  @override
  _QuestionCardState createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: _shortCard(context),
      initiallyExpanded: expanded,
      children: [
        _longCard(context),
      ],
    );
  }

  Widget _longCard(BuildContext context) {
    const TextStyle headerStyle = TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        infoStyle = TextStyle(
          fontSize: 16,
        ),
        contentStyle = TextStyle(
          fontSize: 18,
        );

    return Padding(
      padding: EdgeInsets.only(left: 4, top: 4, right: 4, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Text(
                "Author: ",
                style: headerStyle,
              ),
              Text(widget.question.authorDisplayName, style: infoStyle),
            ],
          ),
          Row(
            children: [
              Text(
                "Platform: ",
                style: headerStyle,
              ),
              Text(widget.question.authorPlatform, style: infoStyle),
            ],
          ),
          Row(
            children: [
              Text(
                "Posted: ",
                style: headerStyle,
              ),
              Text(this.parseDateTime(widget.question.postDate), style: infoStyle),
            ],
          ),
          Divider(
            color: Colors.transparent,
            height: 5,
          ),
          Text(
            widget.question.content,
            style: contentStyle,
            maxLines: null,
          ),
          Divider(
            color: Colors.transparent,
          ),
          Row(
            children: [
              _ratingBar(context),
              Spacer(),
              IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.grey,
                  ),
                  onPressed: () async {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditQuestionPage(widget.question, widget.fbController)))
                        .then((value) => this.setState(() {}));
                  }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _ratingBar(BuildContext context) {
    return RatingBarIndicator(
      rating: widget.question.avgRating,
      itemBuilder: (context, index) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      itemCount: 5,
      itemSize: 30.0,
      unratedColor: Colors.amber.withAlpha(100),
      direction: Axis.horizontal,
    );
  }

  Widget _shortCard(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Card(
        child: Padding(
          padding: EdgeInsets.only(left: 4, top: 8, right: 4, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 200),
                    child: Text(
                      widget.question.authorDisplayName,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Row(
                    children: [
                      Text(timeago.format(this.widget.question.postDate, locale: 'en_short')),
                      Text("    "),
                      Text(
                        widget.question.avgRating.toStringAsFixed(1),
                        style: TextStyle(fontSize: 14),
                      ),
                      Icon(Icons.star, color: Colors.amber, size: 22),
                    ],
                  ),
                ],
              ),
              Text(
                widget.question.content,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.start,
              )
            ],
          ),
        ),
      ),
    );
  }

  String parseDateTime(DateTime d) {
    return d.day.toString().padLeft(2) +
        "/" +
        d.month.toString().padLeft(2) +
        "/" +
        d.year.toString().padLeft(4) +
        "      " +
        d.hour.toString().padLeft(2, "0") +
        ":" +
        d.minute.toString().padLeft(2, "0");
  }
}
