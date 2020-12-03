import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inquirescape/firebase/FirebaseController.dart';
import 'package:inquirescape/firebase/FirebaseListener.dart';
import 'package:inquirescape/widgets/ConferenceCard.dart';
import 'package:inquirescape/widgets/InquireScapeDrawer.dart';

import '../routes.dart';
import 'LoginPage.dart';

class InquireScapeHome extends StatefulWidget {
  InquireScapeHome({Key key}) : super(key: key);

  @override
  _InquireScapeHomeState createState() => _InquireScapeHomeState();
}

class _InquireScapeHomeState extends State<InquireScapeHome> implements FirebaseListener {
  @override
  void initState() {
    super.initState();

    FirebaseController.subscribeListener(this);
  }

  @override
  void dispose() {
    super.dispose();

    FirebaseController.unsubscribeListener(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("InquireScape"),
        centerTitle: true,
      ),
      drawer: FirebaseController.isLoggedIn() ? InquireScapeDrawer() : null,
      body: SafeArea(
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return FirebaseController.isLoggedIn() ? _homePage(context) : LoginPage();
  }

  Widget _loadingScreen(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Divider(
            color: Colors.transparent,
            height: 30,
          ),
          Text("Loading data"),
        ],
      ),
    );
  }

  Widget _homePage(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (FirebaseController.currentConference != null)
            ConferenceCard(
              conference: FirebaseController.currentConference,
              onTap: (_) => () => Navigator.pushNamed(context, routeCurrentConference),
            ),
          _conferenceBlock(context),
          _questionBlock(context),
        ],
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
            child: _largeButton(
              context,
              Icons.spa_rounded,
              "tmp",
              20,
              () {},
            ),
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
                      () => Navigator.pushNamed(context, routePostQuestion)),
                ),
                Expanded(
                  flex: 3,
                  child: _largeButton(context, Icons.format_quote_rounded, "Questions", 14,
                      () => Navigator.pushNamed(context, routeConferenceQuestions)),
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
                      () => Navigator.pushNamed(context, routeAddConference)),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: _largeButton(context, Icons.format_list_bulleted, "Conferences", 20,
                () => Navigator.pushNamed(context, routeConferences).then((_) => this.setState(() {}))),
          ),
        ],
      ),
    );
  }

  Widget _clickableCard(BuildContext context, Widget child, void Function() onTap) {
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
    return _clickableCard(
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

  @override
  void onLoginIncorrect() {}

  @override
  void onLoginSuccess() {
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(routeHome, (Route<dynamic> route) => false);
      setState(() {});
    }
  }

  @override
  void onRegisterDuplicate() {}

  @override
  void onRegisterSuccess() {
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(routeHome, (Route<dynamic> route) => false);
      setState(() {});
    }
  }

  @override
  void onDataChanged() {}

  @override
  void onLogout() {
    if (mounted) {
      setState(() {});
    }
  }
}
