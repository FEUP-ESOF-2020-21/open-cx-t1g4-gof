import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inquirescape/widgets/ConferenceCard.dart';
import 'package:inquirescape/model/Conference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inquirescape/widgets/tags/Tag.dart';
import 'package:mockito/mockito.dart';


// Mock class
class MockDocumentReference extends Mock implements DocumentReference {

}

void main() {

  Conference c;

  setUp(() {
    // Create mock object.
    c = Conference.withoutRef("talk title", "description", "speaker", DateTime.parse("2020-12-03 08:30"), ["topic1", "topic2", "topic3"]);
    DocumentReference mock = MockDocumentReference();
    when(mock.id).thenReturn("abcdefg");
    c.docRef = mock;
  });


  testWidgets("Test title", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: ConferenceCard(conference: c,))));

    // Test Conference title
    final titleFinder = find.text("talk title");
    expect(titleFinder, findsOneWidget);
  });

  testWidgets("Test tag number", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: ConferenceCard(conference: c,))));

    // Test number of tags
    final tagFinder = find.byType(Tag);
    expect(tagFinder, findsNWidgets(3));
  });

  testWidgets("Test date", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: ConferenceCard(conference: c,))));

    // Test date
    final titleFinder = find.text("03-12-2020 08:30");
    expect(titleFinder, findsOneWidget);
  });

}
