import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inquirescape/firebase/FirebaseController.dart';
import 'package:inquirescape/firebase/FirebaseListener.dart';
import 'package:inquirescape/model/Question.dart';
import 'package:inquirescape/themes/MyTheme.dart';
import 'package:inquirescape/widgets/ConferenceCard.dart';
import 'package:inquirescape/widgets/InquireScapeDrawer.dart';
import 'package:inquirescape/widgets/QuestionCard.dart';
import 'package:inquirescape/widgets/SuchEmpty.dart';

import 'package:inquirescape/routes.dart';
import 'package:inquirescape/pages/LoginPage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> implements FirebaseListener {
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

  // Widget _loadingScreen(BuildContext context) {
  //   return Center(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         CircularProgressIndicator(),
  //         Divider(
  //           color: Colors.transparent,
  //           height: 30,
  //         ),
  //         Text("Loading data"),
  //       ],
  //     ),
  //   );
  // }

  Widget _homePage(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: (FirebaseController.currentConference == null || FirebaseController.conferenceQuestions == null)
          ? _homePageWithoutConference(context)
          : _homePageWithConference(context),
    );
  }

  Widget _homePageWithoutConference(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Spacer(flex: 1),
          Expanded(
            flex: 4,
            child: Image(image: AssetImage('assets/InquireScapeLogo.png')),
          ),
          Spacer(flex: 1),
          Expanded(flex: 5, child: _conferencesButton()),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(flex: 1, child: _addConferenceButton()),
                Expanded(flex: 1, child: _invitesButton()),
              ],
            ),
          ),
          Spacer(flex: 1),
        ],
      ),
    );
  }

  Widget _homePageWithConference(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
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
          Expanded(flex: 3, child: _questionList(context)),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 2, child: _postQuestionButton()),
                Expanded(flex: 3, child: _questionsButton()),
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
                        child: SuchEmpty(
                        sizeFactor: 0.6,
                      ))
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
                  child: _invitesButton(),
                ),
                Expanded(
                  flex: 1,
                  child: _addConferenceButton(),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: _conferencesButton(),
          ),
        ],
      ),
    );
  }

  Widget _questionsButton() {
    return _HomeButton(
      icon: Icons.format_quote_rounded,
      text: "Questions",
      fontSize: 14,
      onTap: () => Navigator.pushNamed(context, routeConferenceQuestions),
    );
  }

  Widget _postQuestionButton() {
    return _HomeButton(
      icon: Icons.library_books_rounded,
      text: "Post",
      fontSize: 14,
      onTap: () => Navigator.pushNamed(context, routePostQuestion).then((updated) {
        if (updated != null && updated) this.setState(() {});
      }),
    );
  }

  Widget _invitesButton() {
    return _HomeButton(
      icon: Icons.email,
      text: "Invites",
      fontSize: 14,
      onTap: () => Navigator.pushNamed(context, routeInvites),
    );
  }

  Widget _addConferenceButton() {
    return _HomeButton(
      icon: Icons.add_circle_rounded,
      text: "Create",
      fontSize: 14,
      onTap: () => Navigator.pushNamed(context, routeAddConference),
    );
  }

  Widget _conferencesButton() {
    return _HomeButton(
      icon: Icons.format_list_bulleted,
      text: "Talks",
      fontSize: 20,
      onTap: () => Navigator.pushNamed(context, routeConferences).then((_) => this.setState(() {})),
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
  final Widget child;
  final void Function() onTap;

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
  final void Function() onTap;
  final IconData icon;
  final String text;
  final double fontSize;

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
