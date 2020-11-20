abstract class FirebaseListener {
    void onRegisterSuccess();
    void onRegisterDuplicate();

    void onLoginSuccess();
    void onLoginIncorrect();
}