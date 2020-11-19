import 'package:flutter/material.dart';
import 'package:inquirescape/firebase/FirebaseController.dart';
import 'package:inquirescape/pages/LoginPage.dart';
import 'package:inquirescape/pages/QuestionListPage.dart';
import 'package:inquirescape/widgets/QuestionsHolder.dart';

import 'package:inquirescape/pages/InquireScapeHome.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final FirebaseController firebaseController = FirebaseController();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InquireScape',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // brightness: Brightness.dark,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // on the FirstScreen widget.
      initialRoute: '/',
      routes: {
        '/': (context) => InquireScapeHome(),
        '/login': (context) => LoginPage(firebaseController),
        '/questions': (context) => SafeArea(
              child: QuestionsHolder(
                child: QuestionListPage(),
              ),
            ),
      },
    );
  }
}
