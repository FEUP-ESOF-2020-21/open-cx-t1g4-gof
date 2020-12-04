import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inquirescape/firebase/FirebaseListener.dart';
import 'package:inquirescape/model/Conference.dart';
import 'package:inquirescape/model/Invitation.dart';
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
  static List<Invitation> _myInvitations;

  static List<FirebaseListener> listeners = List();

  static void subscribeListener(FirebaseListener listener) {
    listeners.add(listener);
  }

  static void unsubscribeListener(FirebaseListener listener) {
    listeners.remove(listener);
  }

  static Future<Moderator> addModerator(Moderator moderator, String uid) async {
    moderator.docRef = firebase.collection("moderators").doc(uid);
    await moderator.docRef.set({'email': moderator.email, 'username': moderator.username});

    return moderator;
  }

  static Future<DocumentReference> addConferenceToModerator(Conference conference, Moderator moderator) async {
    DocumentReference ref = moderator.docRef.collection("conferences").doc(conference.docRef.id);

    await ref.set({});
    return ref;
  }

  static Future<Conference> addConference(Conference conference) async {
    conference.docRef = await firebase.collection("conferences").add({
      'title': conference.title,
      'startDate': conference.startDate,
      'description': conference.description,
      'speaker': conference.speaker,
      'topics': conference.topics
    });
    listeners.forEach((FirebaseListener listener) => listener.onDataChanged());
    _myConferences.add(conference);
    _myConferences.sort();
    return conference;
  }

  static Future<Question> addQuestionAndUpdate(Conference conference, Question question) async {
    Question q = await addQuestion(conference, question);
    conferenceQuestions.add(q);
    conferenceQuestions.sort();
    return q;
  }

  static Future<Question> addQuestion(Conference conference, Question question) async {
    question.docRef = await conference.docRef.collection("questions").add({
      'content': question.content,
      'postDate': question.postDate,
      'avgRating': 2.5,
      'totalRatings': 0,
      'authorID': question.authorId,
      'authorDisplayName': question.authorDisplayName,
      'authorPlatform': question.authorPlatform
    });
    listeners.forEach((FirebaseListener listener) => listener.onDataChanged());
    return question;
  }

  static Future<void> updateQuestionContent(Question question) async {
    await question.docRef.set({"content": question.content}, SetOptions(merge: true));
    listeners.forEach((FirebaseListener listener) => listener.onDataChanged());
  }

  static Future<DocumentReference> addRating(Question question, Moderator moderator, double rating) async {
    DocumentReference ratingRef = question.docRef.collection("ratings").doc(moderator.docRef.id);
    await ratingRef.set({'rating': rating});

    question.avgRating = (question.avgRating * question.totalRatings + rating) / (question.totalRatings + 1);
    question.totalRatings++;

    await question.docRef
        .set({"avgRating": question.avgRating, "totalRatings": question.totalRatings}, SetOptions(merge: true));

    listeners.forEach((FirebaseListener listener) => listener.onDataChanged());
    return ratingRef;
  }

  static Future<void> updateRating(Question question, Moderator moderator, double rating) async {
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

  static Future<List<Question>> getQuestions(Conference conference) async {
    List<Question> questions = [];
    QuerySnapshot snapshot = await conference.docRef.collection("questions").get();

    snapshot.docs.forEach((result) {
      Map<String, dynamic> data = result.data();
      if (data == null) return null;

      Question q = Question(
        data["content"],
        DateTime.fromMicrosecondsSinceEpoch(data["postDate"].microsecondsSinceEpoch),
        data["avgRating"].toDouble(),
        data["totalRatings"],
        data["authorID"],
        data["authorDisplayName"],
        data["authorPlatform"],
        result.reference,
      );
      questions.add(q);
    });
    return questions;
  }

  static Future<Conference> getConference(String conferenceId) async {
    return await getConferenceFromDoc(firebase.collection("conferences").doc(conferenceId));
  }

  static Future<Conference> getConferenceFromDoc(DocumentReference doc) async {
    Map<String, dynamic> data = (await doc.get()).data();
    if (data == null) return null;

    return Conference(
      data["title"],
      data["description"],
      data["speaker"],
      DateTime.fromMicrosecondsSinceEpoch(data["startDate"].microsecondsSinceEpoch),
      (data["topics"] as List)?.map((item) => item as String)?.toList(),
      doc,
    );
  }

  static Future<bool> isInvitedTo(Moderator moderator, Conference conference) async {
    QuerySnapshot snapshot = await moderator.docRef.collection("invites").where('conference', isEqualTo: conference.docRef).limit(1).get();
    if (snapshot == null || snapshot.docs == null)
        return false;

    return snapshot.docs.isNotEmpty;
  }

  static Future<bool> isInConference(Moderator moderator, Conference conference) async {
    DocumentReference doc = await moderator.docRef.collection("conferences").doc(conference.docRef.id);
    if (doc == null) return false;

    Map<String, dynamic> data = (await doc.get()).data();
    return data != null;
  }

  static Future<bool> inviteModerator(Moderator recipient, Conference conference, Moderator sender, {bool verifiedExistance: false}) async {
    if (!verifiedExistance) {
      if (await isInConference(recipient, conference) || await isInvitedTo(recipient, conference)) {
        return false;
      }
    }

    DocumentReference ret =
        await recipient.docRef.collection("invites").add({'conference': conference.docRef, 'moderator': sender.docRef});

    return ret != null;
  }

  static Future<List<Invitation>> getInvitations() async {
    List<Invitation> invites = [];
    QuerySnapshot snapshot = await _currentMod.docRef.collection("invites").get();

    await Future.forEach(snapshot.docs, (result) async {
      Map<String, dynamic> data = result.data();
      if (data == null) return null;

      Moderator mod = await getModeratorFromDoc(data["moderator"]);
      Conference conf = await getConferenceFromDoc(data["conference"]);

      Invitation i = new Invitation(
        mod,
        conf,
        result.reference,
      );
      invites.add(i);
    });

    invites.sort();
    return invites;
  }

  static Future<void> acceptInvite(Invitation invite) async {
    await invite.docRef.delete();
    addConferenceToModerator(invite.conference, _currentMod);
    _myInvitations.remove(invite);
    _myConferences.add(invite.conference);
    _myConferences.sort();
  }

  static Future<void> rejectInvite(Invitation invite) async {
    await invite.docRef.delete();
    _myInvitations.remove(invite);
  }

  static Future<Moderator> getModeratorByMail(String email) async {
    email.trim();
    QuerySnapshot snapshot = await firebase.collection('moderators').where('email', isEqualTo: email).limit(1).get();

    if (snapshot.docs.isEmpty) return null;

    Map<String, dynamic> data = snapshot.docs[0].data();
    if (data == null) return null;
    return Moderator(data["username"], data["email"], snapshot.docs[0].reference);
  }

  static Future<Moderator> getModerator(String uid) async {
    return await getModeratorFromDoc(firebase.collection("moderators").doc(uid));
  }

  static Future<Moderator> getModeratorFromDoc(DocumentReference doc) async {
    Map<String, dynamic> data = (await doc.get()).data();

    if (data == null) return null;
    return Moderator(data["username"], data["email"], doc);
  }

  static Future<List<Conference>> getModeratorConferences(Moderator moderator) async {
    QuerySnapshot snapshot = await moderator.docRef.collection("conferences").get();
    List<Conference> result = [];

    await Future.forEach(snapshot.docs, (doc) async => result.add(await getConference(doc.id)));
    result?.sort();

    return result;
  }

  static Future<void> login(String email, String password, FirebaseListener listener) async {
    try {
      String modUid = await FBAuthenticator.signIn(email, password);

      _currentMod = await getModerator(modUid);
      if (_currentMod == null) return listener.onLoginIncorrect();

      await FirebaseController.updateLoginInfo();

      listeners.forEach((FirebaseListener listener) => listener.onLoginSuccess());

      return listener.onLoginSuccess();
    } on FirebaseAuthException catch (exception) {
      return listener.onLoginIncorrect();
    }
  }

  static Future<void> register(String email, String username, String password, FirebaseListener listener) async {
    try {
      String modUid = await FBAuthenticator.signUp(email, password);
      Moderator mod = Moderator.withoutRef(username, email);
      _currentMod = await addModerator(mod, modUid);

      await FirebaseController.updateLoginInfo();

      listeners.forEach((FirebaseListener listener) => listener.onLoginSuccess());
      return listener.onRegisterSuccess();
    } on FirebaseAuthException catch (exception) {
      return listener.onRegisterDuplicate();
    }
  }

  static Future<void> logout() async {
    await FBAuthenticator.signOut();
    _currentMod = null;
    _conferenceQuestions = null;
    _myInvitations = null;
    _conferenceIndex = null;
    _conferenceQuestionsLoadedIndex = null;
    _myConferences = null;
    listeners.forEach((FirebaseListener listener) => listener.onLogout());
  }

  static Moderator get currentMod => _currentMod;

  static List<Conference> get myConferences => _myConferences;

  static Conference get currentConference => _conferenceIndex == null ? null : _myConferences[_conferenceIndex];

  static int get conferenceIndex => _conferenceIndex;

  static List<Invitation> get myInvitations => _myInvitations;

  static set conferenceIndex(int value) {
    _conferenceIndex = value;
    reloadQuestions((_) {});
  }

  static List<Question> get conferenceQuestions => _conferenceQuestions;

  static int get conferenceQuestionsLoadedIndex => _conferenceQuestionsLoadedIndex;

  static Future<void> reloadQuestions(void Function(List<Question>) onReload) async {
    if (_conferenceIndex == null || _myConferences == null || _conferenceIndex == _conferenceQuestionsLoadedIndex)
      return;

    await forceReloadQuestions(onReload);
  }

  static Future<void> forceReloadQuestions(void Function(List<Question>) onReload) async {
    if (_conferenceIndex == null || _myConferences == null) return;

    _conferenceQuestions = await getQuestions(currentConference);
    _conferenceQuestions.sort();
    onReload(_conferenceQuestions);
  }

  static bool isLoggedIn() {
    return FBAuthenticator.isLoggedIn();
  }

  static Future<bool> updateLoginInfo() async {
    User moderator = FBAuthenticator.getCurrentUser();

    if (moderator == null) {
      _currentMod = null;
      return false;
    }
    if (_currentMod == null || moderator.uid != _currentMod.docRef.id) {
      _currentMod = await getModerator(moderator.uid);
    }

    _conferenceIndex = null;
    getModeratorConferences(_currentMod).then((res) {
      _myConferences = res;
    });

    if (_currentMod == null) {
      await logout();
      return false;
    }

    listeners.forEach((FirebaseListener listener) => listener.onLoginSuccess());
    return true;
  }

  static Future<void> reloadInvites(void Function(List<Invitation>) onReload) async {
    await forceReloadInvitations(onReload);
  }

  static Future<void> forceReloadInvitations(void Function(List<Invitation>) onReload) async {
    _myInvitations = await getInvitations();
    onReload(_myInvitations);
  }
}
