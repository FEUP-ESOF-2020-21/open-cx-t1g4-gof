import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inquirescape/firebase/FirebaseController.dart';
import 'package:inquirescape/model/Conference.dart';
import 'file:///D:/FEUP/ESOF/inquirescape/lib/widgets/tags/TagDisplayer.dart';

class InquireScapeHome extends StatelessWidget {
  final FirebaseController _fbController;
  final Widget _drawer;

  InquireScapeHome(this._fbController, this._drawer);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("InquireScape"),
        centerTitle: true,
      ),
      drawer: this._drawer,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _conferenceCard(
                  context,
                  Conference.withoutRef("A rather nice talk", "A short talk about ESOF", "Ademar Aguar", DateTime.now(),
                      ["Flutter", "Dart", "ESOF", "Gherkin"])),
              _conferenceBlock(context),
              _questionBlock(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _questionBlock(BuildContext context) {
    return Container(
      height: 300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: _largeButton(context, Icons.format_list_bulleted, "Conferences", 20,
                () => Navigator.pushNamed(context, "/conference/myConferences")),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 2,
                  child: _largeButton(context, Icons.library_books_rounded, "Post", 14,
                      () => Navigator.pushNamed(context, "/conference/postQuestion")),
                ),
                Expanded(
                  flex: 3,
                  child: _largeButton(context, Icons.format_quote_rounded, "Questions", 14,
                      () => Navigator.pushNamed(context, "/conference/questions")),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _conferenceBlock(BuildContext context) {
    return Container(
      height: 180,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 1,
                  child: _largeButton(context, Icons.email, "Invites", 14, () {}),
                ),
                Expanded(
                  flex: 1,
                  child: _largeButton(context, Icons.add_circle_rounded, "Create", 14,
                      () => Navigator.pushNamed(context, "/conference/create")),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: _largeButton(context, Icons.format_list_bulleted, "Conferences", 20,
                () => Navigator.pushNamed(context, "/conference/myConferences")),
          ),
        ],
      ),
    );
  }

  Widget _mainContainer(BuildContext context, Widget child, void Function() onTap) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      child: InkResponse(
        highlightShape: BoxShape.rectangle,
        customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
          child: child,
        ),
      ),
    );
  }

  Widget _largeButton(BuildContext context, IconData icon, String text, double fontSize, void Function() onTap) {
    return _mainContainer(
      context,
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new Expanded(
            child: new FittedBox(
              fit: BoxFit.contain,
              child: new Icon(icon, color: Theme.of(context).primaryColor),
            ),
          ),
          Divider(height: 2, color: Colors.transparent),
          Text(text, style: TextStyle(fontSize: fontSize))
        ],
      ),
      onTap,
    );
  }

  Widget _conferenceCard(BuildContext context, Conference conference) {
    TextStyle headerStyle = TextStyle(fontSize: 15, color: Theme.of(context).textTheme.bodyText1.color);
    TextStyle infoStyle = TextStyle(fontSize: 20);
    TextStyle dateStyle = TextStyle(fontSize: 12);

    return _mainContainer(
      context,
      Column(
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
      () => Navigator.pushNamed(context, "/conference"),
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
