import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inquirescape/model/Conference.dart';
import 'package:inquirescape/model/User.dart';

class Question {
  DocumentReference docRef;

  Conference conference;
  String content;
  DateTime postDate;
  double avgRating;
  User poster;

  Question(this.docRef, this.conference, this.content, this.postDate,
      this.avgRating, this.poster);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Question &&
          runtimeType == other.runtimeType &&
          docRef == other.docRef;

  @override
  int get hashCode => docRef.hashCode;
}