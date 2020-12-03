import 'package:flutter/material.dart';
import 'package:inquirescape/firebase/FirebaseController.dart';

import 'package:inquirescape/model/Conference.dart';
import 'package:inquirescape/widgets/ConferenceCard.dart';

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
        title: Text("My Conferences"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: this._onRefresh,
          child: conferences == null ? _noConferences(context) : _conferenceList(context, conferences),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    this.setState(() {});
    print("I feel rather refreshed");
  }

  Widget _noConferences(BuildContext context) {
    return Center(
      child: Text(
        "No conferences",
        style: TextStyle(color: Colors.grey, fontSize: 30),
      ),
    );
  }

  Widget _conferenceList(BuildContext context, List<Conference> conferences) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: conferences.length,
      itemBuilder: (BuildContext context, int index) => ConferenceCard(
        conference: conferences[index],
        index: index,
        highlighted: FirebaseController.conferenceIndex == index,
        onTap: (i) { FirebaseController.conferenceIndex = i; setState(() {}); },
      ),
    );
  }

}
