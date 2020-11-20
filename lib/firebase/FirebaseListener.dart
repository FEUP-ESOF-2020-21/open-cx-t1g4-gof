abstract class FirebaseListener {
    void onRegisterSuccess();
    void onRegisterDuplicate();

    void onLoginSuccess();
    void onLoginIncorrect();
    void onLogout();

    void onDataChanged();
}