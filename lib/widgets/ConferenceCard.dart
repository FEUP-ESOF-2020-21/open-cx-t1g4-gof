import 'package:flutter/material.dart';
import 'package:inquirescape/model/Conference.dart';
import 'package:inquirescape/themes/MyTheme.dart';
import 'package:inquirescape/widgets/tags/TagDisplayer.dart';

class ConferenceCard extends StatelessWidget {
  final Conference conference;
  final int index;
  final bool highlighted;
  final void Function(int) onTap;
  final ShapeBorder cardBorder;

  ConferenceCard({@required this.conference, this.onTap, this.index = 0, this.highlighted = false, this.cardBorder});

  static const TextStyle headerStyle = TextStyle(fontSize: 15);
  static const TextStyle infoStyle = TextStyle(fontSize: 20);
  static const TextStyle dateStyle = TextStyle(fontSize: 12);

  @override
  Widget build(BuildContext context) {
    String ref = conference.docRef.id;
    return Hero(
      tag: "conferenceCard{$ref}",
      child: Padding(
        padding: EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
        child: Card(
          shape: cardBorder,
          color: highlighted ? MyTheme.theme.primaryColor.withAlpha(80) : null,
          child: InkResponse(
            highlightShape: BoxShape.rectangle,
            customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            splashColor: MyTheme.theme.primaryColor.withAlpha(30),
            onTap: onTap == null ? null : () => onTap(index),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Title",
                    style: headerStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(conference.title, style: infoStyle),
                  Divider(
                    color: Colors.transparent,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Speaker",
                              style: headerStyle,
                            ),
                            Text(
                              conference.speaker,
                              style: infoStyle,
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Date",
                              style: headerStyle,
                            ),
                            Text(
                              this.fromDateTime(conference.startDate),
                              style: dateStyle,
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.transparent,
                  ),
                  TagDisplayer(
                    tags: conference.topics,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String fromDateTime(DateTime d) {
    return d.day.toString().padLeft(2, "0") +
        "-" +
        d.month.toString().padLeft(2, "0") +
        "-" +
        d.year.toString().padLeft(4, "0") +
        " " +
        d.hour.toString().padLeft(2, "0") +
        ":" +
        d.minute.toString().padLeft(2, "0");
  }
}
