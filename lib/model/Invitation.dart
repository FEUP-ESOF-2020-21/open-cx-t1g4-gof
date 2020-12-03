import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inquirescape/model/Conference.dart';
import 'package:inquirescape/model/Moderator.dart';

class Invitation {
  DocumentReference docRef;

  Moderator user;
  Conference conference;

  Invitation(this.user, this.conference, this.docRef);

  Invitation.withoutRef(this.user, this.conference);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Invitation && runtimeType == other.runtimeType && docRef == other.docRef;

  @override
  int get hashCode => docRef.hashCode;
}
