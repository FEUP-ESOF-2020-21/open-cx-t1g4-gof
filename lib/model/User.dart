import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  DocumentReference docRef;

  String username;
  String platform;

  User(this.username, this.platform);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          docRef == other.docRef;

  @override
  int get hashCode => docRef.hashCode;
}