import 'package:flutter/material.dart';
import 'package:inquirescape/firebase/FirebaseController.dart';

import 'package:inquirescape/model/Conference.dart';
import 'package:inquirescape/widgets/TagDisplayer.dart';

class InvitationsPage extends StatefulWidget {
  final FirebaseController _fbController;
  final Widget _drawer;

  InvitationsPage(this._fbController, this._drawer);

  @override
  _InvitationsPageState createState() => _InvitationsPageState();
}

class _InvitationsPageState extends State<InvitationsPage> {
  List<Conference> conferences = [
    Conference.withoutRef("A talk here", "IntrotoDartadaiufuafapsfgagsf8g",
        "Ademar", DateTime(2020, 11, 22), ["Dart"]),
    Conference.withoutRef("A talk there", "I", "Aguiar", DateTime(2020, 11, 24),
        ["Flutter", "Widgets"]),
  ];
  @override
  Widget build(BuildContext context) {
    // List<Conference> conferences = this.widget._fbController.myConferences;

    return RefreshIndicator(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Pending Invitations"),
          centerTitle: true,
        ),
        drawer: this.widget._drawer,
        body: conferences == null
            ? _noConferences(context)
            : _conferenceList(context, conferences),
      ),
      onRefresh: this._onRefresh,
    );
  }

  Future<void> _onRefresh() async {
    this.setState(() {});
    print("I feel rather refreshed");
  }

  Widget _noConferences(BuildContext context) {
    return Center(
      child: Text(
        "No Conference Invitations",
        style: TextStyle(color: Colors.grey, fontSize: 30),
      ),
    );
  }

  Widget _conferenceList(BuildContext context, List<Conference> conferences) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: conferences.length,
      itemBuilder: (BuildContext context, int index) =>
          _conferenceCard(context, conferences[index], index),
    );
  }

  Widget _conferenceCard(
      BuildContext context, Conference conference, int index) {
    const TextStyle headerStyle = TextStyle(fontSize: 15);
    const TextStyle infoStyle = TextStyle(fontSize: 20);
    const TextStyle dateStyle = TextStyle(fontSize: 12);

    return Padding(
      padding: EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
      child: Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
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
                  tagColor: Colors.white,
                ),
                Divider(
                  color: Colors.transparent,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 160),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Invited by:",
                              style: headerStyle,
                            ),
                            Text(
                              conference.description,
                              style: infoStyle,
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          FlatButton(
                            onPressed: () {},
                            child: Icon(Icons.check, color: Colors.green),
                          ),
                          FlatButton(
                            onPressed: () {},
                            child: Icon(Icons.close, color: Colors.red),
                          )
                        ],
                      ),
                    ]),
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
