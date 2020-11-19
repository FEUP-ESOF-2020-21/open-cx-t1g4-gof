import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inquirescape/model/Conference.dart';
import 'package:inquirescape/model/Moderator.dart';
import 'package:inquirescape/model/Question.dart';

class FirebaseController {
  static final FirebaseFirestore firebase = FirebaseFirestore.instance;

  FirebaseController();

  Future<Moderator> addModerator(Moderator moderator, String uid) async {
    moderator.docRef = firebase.collection("moderators").doc(uid);
    await moderator.docRef.set({'email': moderator.email, 'username': moderator.username, 'name': moderator.name});
    return moderator;
  }

  Future<DocumentReference> addConferenceToModerator(Conference conference, Moderator moderator) async {
    DocumentReference ref = moderator.docRef.collection("conferences").doc(conference.docRef.id);
    await ref.set({});
    return ref;
  }

  Future<Conference> addConference(Conference conference) async {
    conference.docRef = await firebase.collection("conferences").add({
      'title': conference.title,
      'startDate': conference.startDate,
      'description': conference.description,
      'speaker': conference.speaker,
      'topics': conference.topics
    });
    return conference;
  }

  Future<Question> addQuestion(Conference conference, Question question) async {
    question.docRef = await conference.docRef.collection("questions").add({
      'content': question.content,
      'postDate': question.postDate,
      'avgRating': 0.0,
      'totalRatings': 0,
      'authorID': question.authorId,
      'authorDisplayName': question.authorDisplayName,
      'authorPlatform': question.authorPlatform
    });
    return question;
  }

  Future<void> updateQuestionContent(Question question) async {
    await question.docRef.set({"content": question.content}, SetOptions(merge: true));
  }

  Future<DocumentReference> addRating(Question question, Moderator moderator, double rating) async {
    DocumentReference ratingRef = question.docRef.collection("ratings").doc(moderator.docRef.id);
    await ratingRef.set({'rating': rating});

    question.avgRating = (question.avgRating * question.totalRatings + rating) / (question.totalRatings + 1);
    question.totalRatings++;

    await question.docRef
        .set({"avgRating": question.avgRating, "totalRatings": question.totalRatings}, SetOptions(merge: true));

    return ratingRef;
  }

  Future<void> updateRating(Question question, Moderator moderator, double rating) async {
    DocumentReference ratingRef = question.docRef.collection("ratings").doc(moderator.docRef.id);

    double oldRating;
    await ratingRef.get().then((value) {
      oldRating = value.data()["rating"];
    });

    await ratingRef.set({'rating': rating}, SetOptions(merge: true));

    question.avgRating = (question.avgRating * question.totalRatings + (rating - oldRating)) / question.totalRatings;

    await question.docRef.set({"avgRating": question.avgRating}, SetOptions(merge: true));
  }

  Future<List<Question>> getQuestions(Conference conference) async {
    List<Question> questions;
    QuerySnapshot snapshot = await conference.docRef.collection("questions").get();

    snapshot.docs.forEach((result) {
      Map<String, dynamic> data = result.data();
      if (data == null) return null;

      Question q = Question(data["content"], data["postDate"], data["avgRating"],
          data["totalRatings"], data["authorID"], data["authorDisplayName"], data["authorPlatform"], result.reference);
      questions.add(q);
    });

    return questions;
  }

  Future<Conference> getConference(String conferenceId) async {
    DocumentReference conferenceDocRef = firebase.collection("conferences").doc(conferenceId);
    Map<String, dynamic> data = (await conferenceDocRef.get()).data();

    if (data == null) return null;
    return Conference(data["title"], data["description"], data["speaker"], data["startDate"], data["topics"], conferenceDocRef);
  }

  Future<Moderator> getModerator(String uid) async {
    DocumentReference modDocRef = firebase.collection("moderators").doc(uid);
    Map<String, dynamic> data = (await modDocRef.get()).data();

    if (data == null) return null;
    return Moderator(data["username"], data["email"], data["name"], modDocRef);
  }

}
