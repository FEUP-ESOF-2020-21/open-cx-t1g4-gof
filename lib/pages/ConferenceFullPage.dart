import 'package:flutter/material.dart';
import 'package:inquirescape/firebase/FirebaseController.dart';
import 'package:inquirescape/model/Conference.dart';
import 'package:inquirescape/themes/MyTheme.dart';
import 'package:inquirescape/widgets/tags/TagDisplayer.dart';

class ConferenceFullPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const TextStyle headerStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
    const TextStyle infoStyle = TextStyle(fontSize: 20);

    Conference conference = FirebaseController.currentConference;

    const Divider headerInfoDivider = Divider(
      color: Colors.transparent,
      height: 5,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Current Conference"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsetsDirectional.only(start: 8, top: 8, end: 8, bottom: 8),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "Title",
                  style: headerStyle,
                  maxLines: null,
                ),
                headerInfoDivider,
                Text(
                  conference.title,
                  style: infoStyle,
                  maxLines: null,
                ),
                const Divider(color: Colors.transparent),
                const Text(
                  "Speaker",
                  style: headerStyle,
                  maxLines: null,
                ),
                headerInfoDivider,
                Text(
                  conference.speaker,
                  style: infoStyle,
                  maxLines: null,
                ),
                const Divider(color: Colors.transparent),
                const Text(
                  "Date & Time",
                  style: headerStyle,
                  maxLines: null,
                ),
                headerInfoDivider,
                Text(
                  this.fromDateTime(conference.startDate),
                  style: infoStyle,
                  maxLines: null,
                ),
                const Divider(color: Colors.transparent),
                const Text(
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
                const Divider(color: Colors.transparent),
                const Text(
                  "Description",
                  style: headerStyle,
                  maxLines: null,
                ),
                const Divider(color: Colors.transparent, height: 5),
                Text(
                  conference.description == "" ? "(no description added)" : conference.description,
                  style: infoStyle,
                ),
              ],
            ),
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
            color: MyTheme.theme.primaryColor,
            onPressed: () => {}),
      ],
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
