import 'package:inquirescape/widgets/QuestionCard.dart';
import 'package:inquirescape/model/Question.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Question q = Question.withoutRef("content", DateTime.now(), "authorId", "Author Name", "authorPlatform");

  testWidgets("Test content", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: ShortQuestionCard(question: q,))));

    // Test Product Name
    final titleFinder = find.text("content");
    expect(titleFinder, findsOneWidget);
  });

  testWidgets("Test author", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: ShortQuestionCard(question: q,))));

    // Test Product Name
    final titleFinder = find.text("Author Name");
    expect(titleFinder, findsOneWidget);
  });

}
