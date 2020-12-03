import 'package:cloud_firestore/cloud_firestore.dart';

class Conference implements Comparable<Conference> {
  DocumentReference docRef;

  String title;
  String description;
  String speaker;
  DateTime startDate;

  List<String> topics;

  Conference(this.title, this.description, this.speaker, this.startDate, this.topics, this.docRef);

  Conference.withoutRef(this.title, this.description, this.speaker, this.startDate, this.topics);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Conference && runtimeType == other.runtimeType && docRef == other.docRef;

  @override
  int get hashCode => docRef.hashCode;

  @override
  int compareTo(Conference other) {
    return other.startDate.compareTo(this.startDate);
  }
}
