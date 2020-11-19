import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inquirescape/model/Moderator.dart';

class Conference {
  DocumentReference docRef;

  String title;
  String description;
  DateTime startDate;

  List<Moderator> moderators;
  List<String> topics;

  Conference(this.title, this.description, this.startDate, this.moderators, this.topics);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Conference &&
          runtimeType == other.runtimeType &&
          docRef == other.docRef;

  @override
  int get hashCode => docRef.hashCode;
}