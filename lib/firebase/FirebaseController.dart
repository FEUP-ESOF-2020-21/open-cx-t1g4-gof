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
        return await firebase.collection("moderators").
            add({   'email': moderator.email,
                    'username': moderator.username,
                    'name': moderator.name
                });
    }
    
    Future<DocumentReference> addConference(Conference conference) async {
        List<DocumentReference> modRefs = List();
        for (int i = 0; i < conference.moderators.length; i++) {
            modRefs.add(conference.moderators[i].docRef);
        }

        return await firebase.collection("conferences").
            add({   'title': conference.title,
                    'startDate': conference.startDate,
                    'description': conference.description,
                    'moderators': modRefs,
                    'topics': conference.topics
                });
    }

    Future<DocumentReference> addQuestion(Question question) async {
        return await firebase.collection("questions").
            add({   'poster': question.poster.docRef,
                    'content': question.content,
                    'postDate': question.postDate,
                    'conference': question.conference.docRef,
                    'ratings': {},
                    'avgRating': 0.0
                });
    }

    Future<DocumentReference> addUser(User user) async {
        return await firebase.collection("users").
            add({   'username': user.username,
                    'platform': user.platform
                });
    }

    Future<Moderator> getModeratorFromDatabase(DocumentSnapshot document) async {
        DocumentReference docRef = document.reference;
        Map data = document.data();
        if (data == null) return Moderator.invalid();
        return Moderator(data['username'], data['email'], data['name'], docRef);
    }
}