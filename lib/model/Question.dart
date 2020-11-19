import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  DocumentReference docRef;

  String content;
  DateTime postDate;
  double avgRating;
  int totalRatings;
  String authorId, authorDisplayName, authorPlatform;

  Question(this.content, this.postDate,
      this.avgRating, this.totalRatings, this.authorId, this.authorDisplayName, this.authorPlatform, this.docRef);

  Question.withoutRef(this.content, this.postDate, this.authorId, this.authorDisplayName, this.authorPlatform) {
    this.avgRating = 0;
    this.totalRatings = 0;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Question &&
          runtimeType == other.runtimeType &&
          docRef == other.docRef;

  @override
  int get hashCode => docRef.hashCode;
}