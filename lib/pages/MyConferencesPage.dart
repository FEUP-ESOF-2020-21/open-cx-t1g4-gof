import 'package:flutter/material.dart';
import 'package:inquirescape/firebase/FirebaseController.dart';

import 'package:inquirescape/model/Conference.dart';
import 'package:inquirescape/widgets/ConferenceCard.dart';
import 'package:inquirescape/widgets/SuchEmpty.dart';

class MyConferencesPage extends StatefulWidget {
  @override
  _MyConferencesPageState createState() => _MyConferencesPageState();
}

class _MyConferencesPageState extends State<MyConferencesPage> {
  @override
  Widget build(BuildContext context) {
    List<Conference> conferences = FirebaseController.myConferences;

    return Scaffold(
      appBar: AppBar(
        title: Text("My Talks"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: (conferences == null || conferences.isEmpty)
            ? _noConferences(context)
            : _conferenceList(context, conferences),
      ),
    );
  }

  Widget _noConferences(BuildContext context) {
    return Center(
        child: SuchEmpty(
      extraText: "No Talks",
      sizeFactor: 0.5,
    ));
  }

  Widget _conferenceList(BuildContext context, List<Conference> conferences) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: conferences.length,
      itemBuilder: (BuildContext context, int index) => ConferenceCard(
        conference: conferences[index],
        index: index,
        highlighted: FirebaseController.conferenceIndex == index,
        onTap: (i) {
          FirebaseController.conferenceIndex = i;
          setState(() {});
        },
      ),
    );
  }
}
