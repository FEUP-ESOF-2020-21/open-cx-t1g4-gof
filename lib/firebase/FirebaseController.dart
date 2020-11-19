import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:inquirescape/model/Conference.dart';
import 'package:inquirescape/model/Moderator.dart';
import 'package:inquirescape/model/Question.dart';
import 'package:inquirescape/model/User.dart';

class FirebaseController {
  static final FirebaseFirestore firebase = FirebaseFirestore.instance;

  FirebaseController();

  Future<DocumentReference> addModerator(Moderator moderator) async {
    moderator.docRef = await firebase
        .collection("moderators")
        .add({'email': moderator.email, 'username': moderator.username, 'name': moderator.name});
    return moderator.docRef;
  }

  Future<DocumentReference> addConferenceToModerator(Conference conference, Moderator moderator) async {
     DocumentReference ref = moderator.docRef.collection("conferences").doc(conference.docRef.id);
     await ref.set({});
     return ref;
  }

  Future<DocumentReference> addConference(Conference conference) async {
    conference.docRef = await firebase.collection("conferences").add({
      'title': conference.title,
      'startDate': conference.startDate,
      'description': conference.description,
      'author': conference.author,
      'topics': conference.topics
    });
    return conference.docRef;
  }

  Future<DocumentReference> addQuestion(Conference conference, Question question) async {
    question.docRef = await conference.docRef.collection("questions").add({
      'poster': question.poster.docRef,
      'content': question.content,
      'postDate': question.postDate,
      'avgRating': 0.0,
      'totalRatings': 0
    });
    return question.docRef;
  }

  Future<void> updateQuestionContent(Question question) async {
    await question.docRef.set({"content": question.content}, SetOptions(merge: true));
  }

  Future<DocumentReference> addRating(Question question, Moderator moderator, double rating) async {
    DocumentReference ratingRef = question.docRef.collection("ratings").doc(moderator.docRef.id);
    await ratingRef.set({'rating': rating});

    question.avgRating = (question.avgRating * question.totalRatings + rating) / (question.totalRatings + 1);
    question.totalRatings++;

    await question.docRef.set({
      "avgRating": question.avgRating,
      "totalRatings": question.totalRatings
    }, SetOptions(merge: true));

    return ratingRef;
  }

  Future<void> updateRating(Question question, Moderator moderator, double rating) async {
    DocumentReference ratingRef = question.docRef.collection("ratings").doc(moderator.docRef.id);

    double oldRating;
    await ratingRef.get().then((value){
      oldRating = value.data()["rating"];
    });

    await ratingRef.set({'rating': rating}, SetOptions(merge: true));

    question.avgRating = (question.avgRating * question.totalRatings + (rating - oldRating)) / question.totalRatings;

    await question.docRef.set({
      "avgRating": question.avgRating
    }, SetOptions(merge: true));
  }

  Future<DocumentReference> addUser(Conference conference, User user) async {
    user.docRef = await conference.docRef.collection("users").add({'username': user.username, 'platform': user.platform});
    return user.docRef;
  }

  // Future<Moderator> getModeratorFromDatabase(DocumentSnapshot document) async {
  //   DocumentReference docRef = document.reference;
  //   Map data = document.data();
  //   if (data == null) return Moderator.invalid();
  //   return Moderator(data['username'], data['email'], data['name'], docRef);
  // }
}
