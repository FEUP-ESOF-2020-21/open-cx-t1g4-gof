import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseController {
    static final FirebaseAuth _auth = FirebaseAuth.instance;

    static User _user;

    Future<String> signUp(String email, String password) async {
      try {
        UserCredential userCreds = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        _user = _auth.currentUser;

        if (!_user.emailVerified) {
          await _user.sendEmailVerification();
        }

      } on FirebaseAuthException catch (exception) {
        if (exception.code == 'weak-password') {
          return "Your password is too weak";
        }
        else if (exception.code == 'email-already-in-use') {
          return "Email is already being used";
        }
      }
      catch (exception) {
        return exception.toString();
      }

      return null;
    }

    Future<String> signIn(String email, String password) async {
      try {
        UserCredential userCreds = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } on FirebaseAuthException catch (exception) {
        if (exception.code == 'user-not-found') {
          return "Email or password incorrect";
        } else if (exception.code == 'wrong-password') {
          return "Email or password incorrect";
        }
      }
      return null;
    }

}