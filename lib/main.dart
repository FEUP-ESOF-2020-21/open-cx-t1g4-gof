import 'package:flutter/material.dart';
import 'package:inquirescape/firebase/FirebaseController.dart';
import 'package:inquirescape/pages/AboutPage.dart';
import 'package:inquirescape/pages/AddConferencePage.dart';
import 'package:inquirescape/pages/ConferenceFullPage.dart';
import 'package:inquirescape/pages/InvitationsPage.dart';
import 'package:inquirescape/pages/MyConferencesPage.dart';
import 'package:inquirescape/pages/PostQuestionPage.dart';
import 'package:inquirescape/pages/ProfilePage.dart';
import 'package:inquirescape/pages/QuestionListPage.dart';
import 'package:inquirescape/pages/SettingsPage.dart';
import 'package:inquirescape/routes/FadeAnimationRoute.dart';
import 'package:inquirescape/routes/SlideAnimationRoute.dart';
import 'package:inquirescape/themes/MyTheme.dart';

import 'package:inquirescape/routes.dart';

import 'package:inquirescape/pages/HomePage.dart';

import 'package:firebase_core/firebase_core.dart';

import 'config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseController.updateLoginInfo();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    currentTheme.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InquireScape',
      themeMode: MyTheme.currentThemeMode(),
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      // on the FirstScreen widget.
      debugShowCheckedModeBanner: false,
      initialRoute: routeHome,
      onGenerateRoute: generateRoutes,
    );
  }

  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case routeHome:
        return FadeAnimationRoute(builder: (_) => HomePage(key: Key("HomePage")));
      case routeCurrentConference:
        return FadeAnimationRoute(builder: (_) => ConferenceFullPage());
      case routeConferenceQuestions:
        return FadeAnimationRoute(builder: (_) => QuestionListPage());
      case routeAddConference:
        return FadeAnimationRoute(builder: (_) => AddConferencePage());
      case routeConferences:
        return FadeAnimationRoute(builder: (_) => MyConferencesPage());
      case routeInvites:
        return FadeAnimationRoute(builder: (_) => InvitationsPage());
      case routePostQuestion:
        return FadeAnimationRoute(builder: (_) => PostQuestionPage());
      case routeProfile:
        return SlideAnimationRoute(builder: (_) => ProfilePage());
      case routeSettings:
        return SlideAnimationRoute(builder: (_) => SettingsPage());
      case routeAbout:
        return SlideAnimationRoute(builder: (_) => AboutPage());
      default:
        return FadeAnimationRoute(
            builder: (_) => Scaffold(
                  body: Center(child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
