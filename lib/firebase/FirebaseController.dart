import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inquirescape/firebase/FirebaseListener.dart';
import 'package:inquirescape/model/Conference.dart';
import 'package:inquirescape/model/Moderator.dart';
import 'package:inquirescape/model/Question.dart';
import 'package:inquirescape/firebase/FirebaseAuthenticator.dart';

class FirebaseController {
  static final FirebaseFirestore firebase = FirebaseFirestore.instance;
  static Moderator _currentMod;

  static List<Conference> _myConferences;
  static int _conferenceIndex;
  static List<Question> _conferenceQuestions;
  static int _conferenceQuestionsLoadedIndex;

  List<FirebaseListener> listeners;

  FirebaseController() {
    this.listeners = List();
  }

  void subscribeListener(FirebaseListener listener) {
    listeners.add(listener);
  }

  void unsubscribeListener(FirebaseListener listener) {
    listeners.remove(listener);
  }

  Future<Moderator> addModerator(Moderator moderator, String uid) async {
    moderator.docRef = firebase.collection("moderators").doc(uid);
    await moderator.docRef.set({'email': moderator.email, 'username': moderator.username});

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
    listeners.forEach((FirebaseListener listener) => listener.onDataChanged());
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
    listeners.forEach((FirebaseListener listener) => listener.onDataChanged());
    return question;
  }

  Future<void> updateQuestionContent(Question question) async {
    await question.docRef.set({"content": question.content}, SetOptions(merge: true));
    listeners.forEach((FirebaseListener listener) => listener.onDataChanged());
  }

  Future<DocumentReference> addRating(Question question, Moderator moderator, double rating) async {
    DocumentReference ratingRef = question.docRef.collection("ratings").doc(moderator.docRef.id);
    await ratingRef.set({'rating': rating});

    question.avgRating = (question.avgRating * question.totalRatings + rating) / (question.totalRatings + 1);
    question.totalRatings++;

    await question.docRef
        .set({"avgRating": question.avgRating, "totalRatings": question.totalRatings}, SetOptions(merge: true));

    listeners.forEach((FirebaseListener listener) => listener.onDataChanged());
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
    listeners.forEach((FirebaseListener listener) => listener.onDataChanged());
  }

  Future<List<Question>> getQuestions(Conference conference) async {
    List<Question> questions;
    QuerySnapshot snapshot = await conference.docRef.collection("questions").get();

    snapshot.docs.forEach((result) {
      Map<String, dynamic> data = result.data();
      if (data == null) return null;

      Question q = Question(data["content"], data["postDate"], data["avgRating"], data["totalRatings"],
          data["authorID"], data["authorDisplayName"], data["authorPlatform"], result.reference);
      questions.add(q);
    });
    return questions;
  }

  Future<Conference> getConference(String conferenceId) async {
    DocumentReference conferenceDocRef = firebase.collection("conferences").doc(conferenceId);
    Map<String, dynamic> data = (await conferenceDocRef.get()).data();

    if (data == null) return null;

    return Conference(
      data["title"],
      data["description"],
      data["speaker"],
      DateTime.fromMicrosecondsSinceEpoch(data["startDate"].microsecondsSinceEpoch),
      (data["topics"] as List)?.map((item) => item as String)?.toList(),
      conferenceDocRef,
    );
  }

  Future<Moderator> getModerator(String uid) async {
    DocumentReference modDocRef = firebase.collection("moderators").doc(uid);
    Map<String, dynamic> data = (await modDocRef.get()).data();

    if (data == null) return null;
    return Moderator(data["username"], data["email"], modDocRef);
  }

  Future<List<Conference>> getModeratorConferences(Moderator moderator) async {
    QuerySnapshot snapshot = await moderator.docRef.collection("conferences").get();
    List<Conference> result = [];

    snapshot.docs.forEach((doc) async => result.add(await this.getConference(doc.id)));

    return result;
  }

  Future<void> login(String email, String password, FirebaseListener listener) async {
    try {
      String modUid = await FBAuthenticator.signIn(email, password);

      _currentMod = await this.getModerator(modUid);
      if (_currentMod == null) return listener.onLoginIncorrect();

      listeners.forEach((FirebaseListener listener) => listener.onLoginSuccess());
      return listener.onLoginSuccess();
    } on FirebaseAuthException catch (exception) {
      return listener.onLoginIncorrect();
    }
  }

  Future<void> register(String email, String username, String password, FirebaseListener listener) async {
    try {
      String modUid = await FBAuthenticator.signUp(email, password);
      Moderator mod = Moderator.withoutRef(username, email);
      _currentMod = await this.addModerator(mod, modUid);

      listeners.forEach((FirebaseListener listener) => listener.onLoginSuccess());
      return listener.onRegisterSuccess();
    } on FirebaseAuthException catch (exception) {
      return listener.onRegisterDuplicate();
    }
  }

  Future<void> logout() async {
    await FBAuthenticator.signOut();
    _currentMod = null;
    listeners.forEach((FirebaseListener listener) => listener.onLogout());
  }

  Moderator get currentMod => _currentMod;

  List<Conference> get myConferences => _myConferences;

  Conference get currentConference => _conferenceIndex == null ? null : _myConferences[_conferenceIndex];

  int get conferenceIndex => _conferenceIndex;
  set conferenceIndex(int value) {
    _conferenceIndex = value;
  }

  List<Question> get conferenceQuestions => _conferenceQuestions;

  int get conferenceQuestionsLoadedIndex => _conferenceQuestionsLoadedIndex;

  Future<void> reloadQuestions(void Function(List<Question>) onReload) async {
    if (_conferenceIndex == null || _myConferences == null || _conferenceIndex != _conferenceQuestionsLoadedIndex)
      return;

    await forceReloadQuestions(onReload);
  }

  Future<void> forceReloadQuestions(void Function(List<Question>) onReload) async {
    if (_conferenceIndex == null || _myConferences == null)
      return;

    _conferenceQuestions = await getQuestions(currentConference);
    onReload(_conferenceQuestions);
  }

  Future<bool> isLoggedIn() async {
    User moderator = FBAuthenticator.getCurrentUser();
    if (moderator == null) {
      _currentMod = null;
      return false;
    }
    if (_currentMod == null || moderator.uid != _currentMod.docRef.id) {
      _currentMod = await this.getModerator(moderator.uid);
      _conferenceIndex = null;
      this.getModeratorConferences(_currentMod).then((res) {
        _myConferences = res;
      });
    }
    if (_currentMod == null) {
      await FBAuthenticator.signOut();
      listeners.forEach((FirebaseListener listener) => listener.onLogout());
      return false;
    }
    listeners.forEach((FirebaseListener listener) => listener.onLoginSuccess());
    return true;
  }
}
