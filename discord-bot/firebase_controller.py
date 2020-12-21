from google.cloud import firestore

from models.question import Question
from models.talk import Talk

class FirebaseController:

    db = None

    @classmethod
    def initialize(cls):
        # Use a service account
        # Project ID is determined by the GCLOUD_PROJECT environment variable
        if (cls.db == None):
            cls.db = firestore.Client()

    @classmethod
    def getTalk(cls, id_talk):
        doc = cls.db.collection(u'conferences').document(id_talk).get()
        if doc.exists:
            return Talk(doc.to_dict())
        else:
            return None

    @classmethod
    def addQuestion(cls, id_talk, question):
        collection = cls.db.collection(u'conferences').document(id_talk).collection(u'questions')
        collection.add(question.q)

FirebaseController.initialize()
