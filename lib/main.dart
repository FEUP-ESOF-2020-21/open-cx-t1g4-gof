import 'package:flutter/material.dart';
import 'package:inquirescape/firebase/FirebaseController.dart';
import 'package:inquirescape/pages/AddConferencePage.dart';
import 'package:inquirescape/pages/ConferenceFullPage.dart';
import 'package:inquirescape/pages/MyConferencesPage.dart';
import 'package:inquirescape/pages/LoginPage.dart';
import 'package:inquirescape/pages/PostQuestionPage.dart';
import 'package:inquirescape/pages/QuestionListPage.dart';
import 'package:inquirescape/themes/MyTheme.dart';
import 'package:inquirescape/widgets/InquireScapeDrawer.dart';

import 'package:inquirescape/pages/InquireScapeHome.dart';

import 'package:firebase_core/firebase_core.dart';

import 'config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static final FirebaseController firebaseController = FirebaseController();

  static final Widget drawer = InquireScapeDrawer(firebaseController);

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
      initialRoute: '/',
      routes: {
        '/': (context) => InquireScapeHome(MyApp.firebaseController, MyApp.drawer),
        '/login': (context) => LoginPage(
          key: Key("LoginPage"),
          fbController: MyApp.firebaseController,
          drawer: MyApp.drawer,
        ),
        '/conference': (context) => ConferenceFullPage(MyApp.firebaseController),
        '/conference/questions': (context) => QuestionListPage(MyApp.firebaseController),
          '/conference/create': (context) => AddConferencePage(MyApp.firebaseController),
        '/conference/myConferences': (context) => MyConferencesPage(MyApp.firebaseController),
        '/conference/invites': (context) => MyConferencesPage(MyApp.firebaseController),
        '/conference/postQuestion': (context) => PostQuestionPage(MyApp.firebaseController),
      },
    );
  }
}
