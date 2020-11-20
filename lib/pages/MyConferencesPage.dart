import 'package:flutter/material.dart';
import 'package:inquirescape/firebase/FirebaseController.dart';

import 'package:inquirescape/model/Conference.dart';
import 'package:inquirescape/widgets/InquireScapeDrawer.dart';
import 'package:inquirescape/widgets/TagDisplayer.dart';

class MyConferencesPage extends StatefulWidget {
  final FirebaseController _fbController;
  final Widget _drawer;

  MyConferencesPage(this._fbController, this._drawer);

  @override
  _MyConferencesPageState createState() => _MyConferencesPageState();
}

class _MyConferencesPageState extends State<MyConferencesPage> {
  List<Conference> conferences = [
    Conference.withoutRef("A talk here", "Intro to Dart", "Ademar", DateTime(2020, 11, 22), ["Dart"]),
    Conference.withoutRef("A talk there", "Intro to Flutter", "Aguiar", DateTime(2020, 11, 24), ["Flutter", "Widgets"]),
  ];

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Conferences"),
          centerTitle: true,
        ),
        drawer: this.widget._drawer,
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
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: this.conferences.length,
      itemBuilder: (BuildContext context, int index) => _conferenceCard(context, this.conferences[index]),
    );
  }

  Widget _conferenceCard(BuildContext context, Conference conference) {
    TextStyle headerStyle = TextStyle(fontSize: 15);
    TextStyle infoStyle = TextStyle(fontSize: 20);
    TextStyle dateStyle = TextStyle(fontSize: 12);

    return Padding(
      padding: EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
      child: Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () => print("Ahoy mate"),
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
                TagDisplayer(tags: conference.topics),
              ],
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
