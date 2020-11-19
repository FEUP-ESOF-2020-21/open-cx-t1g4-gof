import 'package:cloud_firestore/cloud_firestore.dart';

class Moderator {
  DocumentReference docRef;

  String username;
  String email;
  String name;

  Moderator(this.username, this.email, this.name, this.docRef);

  Moderator.withoutRef(this.username, this.email, this.name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Moderator &&
          runtimeType == other.runtimeType &&
          docRef == other.docRef;

  @override
  int get hashCode => docRef.hashCode;
}