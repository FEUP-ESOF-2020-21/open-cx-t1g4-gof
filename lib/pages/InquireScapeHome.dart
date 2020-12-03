import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inquirescape/firebase/FirebaseController.dart';
import 'package:inquirescape/firebase/FirebaseListener.dart';
import 'package:inquirescape/model/Question.dart';
import 'package:inquirescape/themes/MyTheme.dart';
import 'package:inquirescape/widgets/ConferenceCard.dart';
import 'package:inquirescape/widgets/InquireScapeDrawer.dart';
import 'package:inquirescape/widgets/QuestionCard.dart';

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
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (FirebaseController.currentConference != null)
            ConferenceCard(
              conference: FirebaseController.currentConference,
              onTap: (_) => Navigator.pushNamed(context, routeCurrentConference),
              cardBorder: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
          Expanded(
            flex: 3,
            child: _conferenceBlock(context),
          ),
          Expanded(
            flex: 4,
            child: _questionBlock(context),
          ),
        ],
      ),
    );
  }

  Widget _questionBlock(BuildContext context) {
    return Container(
      height: 260,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: _questionList(context),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 2,
                  child: _HomeButton(
                      icon: Icons.library_books_rounded,
                      text: "Post",
                      fontSize: 14,
                      onTap: () => Navigator.pushNamed(context, routePostQuestion)),
                ),
                Expanded(
                  flex: 3,
                  child: _HomeButton(
                    icon: Icons.format_quote_rounded,
                    text: "Questions",
                    fontSize: 14,
                    onTap: () => Navigator.pushNamed(context, routeConferenceQuestions),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _questionList(context) {
    List<Question> questions = FirebaseController.conferenceQuestions;
    int len = questions.length > 3 ? 3 : questions.length;

    return _HomeCard(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                "Recent questions",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.left,
              ),
            ),
            Flexible(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: len == 0
                    ? Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 100),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  // child: Icon(Icons.bathtub, color: MyTheme.theme.primaryColor,),
                                  // child: Icon(Icons.bathtub, color: MyTheme.theme.primaryColor,),
                                  child: Icon(Icons.pest_control_rodent_outlined, color: MyTheme.theme.accentColor,),
                                ),
                              ),
                              Text("Wow such empty", style: TextStyle(fontSize: 18)),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: len,
                        itemBuilder: (context, index) {
                          return ShortQuestionCard(question: questions[index]);
                        },
                      ),
              ),
            ),
          ],
        ),
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
                  child: _HomeButton(
                    icon: Icons.email,
                    text: "Invites",
                    fontSize: 14,
                    onTap: () {},
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: _HomeButton(
                    icon: Icons.add_circle_rounded,
                    text: "Create",
                    fontSize: 14,
                    onTap: () => Navigator.pushNamed(context, routeAddConference),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: _HomeButton(
                icon: Icons.format_list_bulleted,
                text: "Conferences",
                fontSize: 20,
                onTap: () => Navigator.pushNamed(context, routeConferences).then((_) => this.setState(() {}))),
          ),
        ],
      ),
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

class _HomeCard extends StatelessWidget {
  Widget child;
  void Function() onTap;

  _HomeCard({@required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      child: onTap == null
          ? child
          : InkResponse(
              highlightShape: BoxShape.rectangle,
              customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              onTap: onTap,
              child: Container(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                child: child,
              ),
            ),
    );
  }
}

class _HomeButton extends StatelessWidget {
  void Function() onTap;
  IconData icon;
  String text;
  double fontSize;

  _HomeButton({@required this.icon, @required this.text, @required this.onTap, this.fontSize = 16});

  @override
  Widget build(BuildContext context) {
    return _HomeCard(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: FittedBox(
              fit: BoxFit.contain,
              child: Icon(icon, color: MyTheme.theme.accentColor),
            ),
          ),
          Divider(height: 2, color: Colors.transparent),
          Text(text, style: TextStyle(fontSize: fontSize))
        ],
      ),
    );
  }
}
