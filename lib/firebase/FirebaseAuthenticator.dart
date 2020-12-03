import 'package:firebase_auth/firebase_auth.dart';

class FBAuthenticator {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static User getCurrentUser() {
    return _auth.currentUser;
  }

  static bool isLoggedIn() {
    return _auth.currentUser != null;
  }

  static Future<String> signUp(String email, String password) async {
    UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

    return credential.user.uid;
  }

  static Future<String> signIn(String email, String password) async {
    UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);

    return credential.user.uid;
  }

  static Future<UserCredential> reauthenticate(String password) async {
    User user = getCurrentUser();
    AuthCredential credential = EmailAuthProvider.credential(email: user.email, password: password);
    return await user.reauthenticateWithCredential(credential);
  }

  static Future<void> signOut() async {
    return await _auth.signOut();
  }

  static Future<void> sendEmailVerification() async {
    return await getCurrentUser().sendEmailVerification();
  }

  static bool userHasEmailVerified() {
    return getCurrentUser().emailVerified;
  }

  static Future<void> sendResetPasswordEmail(String email) async {
    return await _auth.sendPasswordResetEmail(email: email);
  }
}
