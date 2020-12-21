import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:inquirescape/model/Question.dart';
import 'package:inquirescape/pages/EditQuestionPage.dart';
import 'package:inquirescape/routes/FadeAnimationRoute.dart';
import 'package:inquirescape/themes/MyTheme.dart';
import 'package:inquirescape/firebase/FirebaseController.dart';

import 'package:timeago/timeago.dart' as timeago;

class ShortQuestionCard extends StatelessWidget {
  final Question question;
  final int maxLines;

  ShortQuestionCard({@required this.question, this.maxLines = 3});

  @override
  Widget build(BuildContext context) {
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
                      question.authorDisplayName,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Row(
                    children: [
                      Text(timeago.format(question.postDate, locale: 'en_short')),
                      Text("    "),
                      Text(
                        question.avgRating.toStringAsFixed(1),
                        style: TextStyle(fontSize: 14),
                      ),
                      Icon(Icons.star, color: MyTheme.theme.accentColor, size: 22),
                    ],
                  ),
                ],
              ),
              Text(
                question.content,
                overflow: TextOverflow.ellipsis,
                maxLines: maxLines,
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.start,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ExpandableQuestionCard extends StatefulWidget {
  final Question question;
  final int questionIndex;
  final void Function() onUpdate;

  ExpandableQuestionCard({Key key, @required this.question, @required this.questionIndex, this.onUpdate})
      : super(key: key);

  @override
  _ExpandableQuestionCardState createState() => _ExpandableQuestionCardState();
}

class _ExpandableQuestionCardState extends State<ExpandableQuestionCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: ShortQuestionCard(
        question: widget.question,
      ),
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
                "Author:      ",
                style: headerStyle,
              ),
              Text(widget.question.authorDisplayName, style: infoStyle),
            ],
          ),
          Row(
            children: [
              Text(
                "Platform:   ",
                style: headerStyle,
              ),
              Text(widget.question.authorPlatform, style: infoStyle),
            ],
          ),
          Row(
            children: [
              Text(
                "Posted:      ",
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
            height: widget.question.myRating == null ? 30 : null,
          ),
          if (widget.question.myRating == null)
            Text(
              "Rate this Question",
              style: TextStyle(fontSize: 12),
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
                  onPressed: () => Navigator.push(
                          context, FadeAnimationRoute(builder: (context) => EditQuestionPage(widget.question)))
                      .then((_) => this.setState(() {}))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _ratingBar(BuildContext context) {
    return RatingBar.builder(
      initialRating: widget.question.myRating == null ? 0 : widget.question.myRating,
      itemBuilder: (context, index) => Icon(
        Icons.star,
        color: MyTheme.theme.accentColor,
      ),
      itemCount: 5,
      itemSize: 30.0,
      unratedColor: MyTheme.theme.backgroundColor.withAlpha(100),
      direction: Axis.horizontal,
      allowHalfRating: true,
      onRatingUpdate: (rating) async {
        await FirebaseController.updateRating(widget.question, rating);
        setState(() {});
      },
    );
  }

  String parseDateTime(DateTime d) {
    return d.day.toString().padLeft(2, "0") +
        "/" +
        d.month.toString().padLeft(2, "0") +
        "/" +
        d.year.toString().padLeft(4, "0") +
        "      " +
        d.hour.toString().padLeft(2, "0") +
        ":" +
        d.minute.toString().padLeft(2, "0");
  }
}
