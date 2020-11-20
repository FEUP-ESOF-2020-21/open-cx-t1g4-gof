import 'package:flutter/material.dart';
import 'package:inquirescape/model/Conference.dart';
import 'package:inquirescape/widgets/InquireScapeDrawer.dart';
import 'package:inquirescape/widgets/TagDisplayer.dart';

class ConferenceFullPage extends StatelessWidget {
  final Conference conference = Conference.withoutRef(
      "Introdução a Flutter",
      "Uma breve introdução a uma simples ferramente para criar mobile apps e com uma documentação sem paralelo",
      "Ademar Aguiar",
      DateTime(2020, 11, 24, 11, 30),
      ["Flutter", "Widgets", "Firebase"]);

  @override
  Widget build(BuildContext context) {
    TextStyle headerStyle = const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
    TextStyle infoStyle = const TextStyle(fontSize: 20);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Current Conference"),
          centerTitle: true,
        ),
        drawer: InquireScapeDrawer(),
        body: Container(
          padding: EdgeInsetsDirectional.only(start: 8, top: 8, end: 8, bottom: 8),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Title",
                  style: headerStyle,
                  maxLines: null,
                ),
                Text(
                  conference.title,
                  style: infoStyle,
                  maxLines: null,
                ),
                Divider(
                  color: Colors.transparent,
                ),
                Text(
                  "Speaker",
                  style: headerStyle,
                  maxLines: null,
                ),
                Text(
                  conference.speaker,
                  style: infoStyle,
                  maxLines: null,
                ),
                Divider(
                  color: Colors.transparent,
                ),
                Text(
                  "Date & Time",
                  style: headerStyle,
                  maxLines: null,
                ),
                Text(
                  this.fromDateTime(conference.startDate),
                  style: infoStyle,
                  maxLines: null,
                ),
                Divider(
                  color: Colors.transparent,
                ),
                Text(
                  "Topics",
                  style: headerStyle,
                  maxLines: null,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: TagDisplayer(
                    tags: conference.topics,
                    tagSize: 18,
                  ),
                ),
                Divider(
                  color: Colors.transparent,
                ),
                Text(
                  "Description",
                  style: headerStyle,
                  maxLines: null,
                ),
                Text(
                  conference.description,
                  style: infoStyle,
                ),
              ],
            ),
          ),
        ),
        persistentFooterButtons: [
          FlatButton(
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0),
              ),
              child: Text(
                "Invite Moderators",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              color: Colors.blue,
              onPressed: () => {}),
        ],
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
