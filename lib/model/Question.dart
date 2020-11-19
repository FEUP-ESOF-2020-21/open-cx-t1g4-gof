import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inquirescape/model/User.dart';

class Question {
  DocumentReference docRef;

  String content;
  DateTime postDate;
  double avgRating;
  int totalRatings;
  User poster;

  Question(this.docRef, this.content, this.postDate,
      this.avgRating, this.totalRatings, this.poster);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Question &&
          runtimeType == other.runtimeType &&
          docRef == other.docRef;

  @override
  int get hashCode => docRef.hashCode;
}