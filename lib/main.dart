import 'package:flutter/material.dart';
import 'package:inquirescape/firebase/FirebaseController.dart';
import 'package:inquirescape/pages/AddConferencePage.dart';
import 'package:inquirescape/pages/ConferenceFullPage.dart';
import 'package:inquirescape/pages/MyConferencesPage.dart';
import 'package:inquirescape/pages/PostQuestionPage.dart';
import 'package:inquirescape/pages/QuestionListPage.dart';
import 'package:inquirescape/routes/SlideAnimationRoute.dart';
import 'package:inquirescape/themes/MyTheme.dart';

import 'package:inquirescape/routes.dart';

import 'package:inquirescape/pages/InquireScapeHome.dart';

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
      initialRoute: routeHome,
      onGenerateRoute: generateRoutes,
    );
  }

  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case routeHome:
        return SlideAnimationRoute(builder: (_) => InquireScapeHome());
      case routeCurrentConference:
        return SlideAnimationRoute(builder: (_) => ConferenceFullPage());
      case routeConferenceQuestions:
        return SlideAnimationRoute(builder: (_) => QuestionListPage());
      case routeAddConference:
        return SlideAnimationRoute(builder: (_) => AddConferencePage());
      case routeConferences:
        return SlideAnimationRoute(builder: (_) => MyConferencesPage());
      case routeInvites:
        return SlideAnimationRoute(builder: (_) => MyConferencesPage());
      case routePostQuestion:
        return SlideAnimationRoute(builder: (_) => PostQuestionPage());
      default:
        return SlideAnimationRoute(
            builder: (_) => Scaffold(
                  body: Center(child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
