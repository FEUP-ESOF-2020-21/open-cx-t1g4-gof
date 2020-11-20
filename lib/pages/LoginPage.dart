import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:inquirescape/firebase/FirebaseAuthenticator.dart';
import 'package:inquirescape/firebase/FirebaseController.dart';
import 'package:inquirescape/firebase/FirebaseListener.dart';
import 'package:inquirescape/pages/Validators.dart';
import 'package:inquirescape/widgets/InquireScapeDrawer.dart';

class LoginPage extends StatefulWidget {
  final FirebaseController _fbController;

  LoginPage(this._fbController);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _loginPage = true; // If true -> display Login; If false -> Display Register
  TextEditingController _emailController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passowrdController = TextEditingController();
  TextEditingController _confirmPassowrdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("InquireScape"),
          centerTitle: true,
        ),
        drawer: InquireScapeDrawer(),
        body: Container(
          margin: EdgeInsetsDirectional.only(top: 10.0, bottom: 10.0),
          child: SingleChildScrollView(
            child: _loginPage ? loginPage() : registerPage(),
          ),
        ),
      ),
    );
  }

  Widget loginPage() {
    return Column(
      children: <Widget>[
        Icon(
          Icons.account_circle_rounded,
          size: 200.0,
        ),
        Container(
          margin: EdgeInsetsDirectional.only(
              top: 20.0, start: 20.0, end: 20.0),
          alignment: Alignment.centerLeft,
          child: _loginTextInput('Enter your email', Icons.email, _emailController),
        ),
        Container(
          margin: EdgeInsetsDirectional.only(
              top: 20.0, start: 20.0, end: 20.0),
          alignment: Alignment.centerLeft,
          child: _loginTextInput('Enter your password', Icons.vpn_key, _passowrdController, isPassword: true),
        ),
        Container(
          margin: EdgeInsetsDirectional.only(
              top: 10.0, start: 20.0, end: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _switchStateButton("Create an account?", () => setState(() => _loginPage = false)),
              _switchStateButton("Forgot password?", () {}),
            ],
          ),
        ),
        Container (
          child: _loginSubmit("Login", Icons.login, () {}),
        ),
      ],
    );
  }

  Widget registerPage() {
    return Column(
      children: <Widget>[
        Icon(
          Icons.person,
          size: 200.0,
        ),
        Container(
          margin: EdgeInsetsDirectional.only(
              top: 20.0, start: 20.0, end: 20.0),
          alignment: Alignment.centerLeft,
          child: _loginTextInput('Enter your email', Icons.email, _emailController, validator: Validators.emailValidator())
        ),
        Container(
            margin: EdgeInsetsDirectional.only(
                top: 20.0, start: 20.0, end: 20.0),
            alignment: Alignment.centerLeft,
            child: _loginTextInput('Enter your username', Icons.person, _usernameController, validator: Validators.usernameValidator()),
        ),
        Container(
          margin: EdgeInsetsDirectional.only(
              top: 20.0, start: 20.0, end: 20.0),
          alignment: Alignment.centerLeft,
          child: _loginTextInput('Enter your password', Icons.vpn_key, _passowrdController, isPassword: true, validator: Validators.passwordValidator()),
        ),
        Container(
          margin: EdgeInsetsDirectional.only(
              top: 20.0, start: 20.0, end: 20.0),
          alignment: Alignment.centerLeft,
          child: _loginTextInput('Confirm your password', Icons.vpn_key, _confirmPassowrdController, isPassword: true, validator: Validators.confirmPasswordValidator(_passowrdController)),
        ),
        Container(
          margin: EdgeInsetsDirectional.only(
              top: 10.0, start: 20.0, end: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _switchStateButton("Already have an account?", () => setState(() => _loginPage = true)),
            ],
          ),
        ),
        Container (
          child: _loginSubmit("Register", Icons.login, () {}),
        ),
      ],
    );
  }

  Widget _switchStateButton(String text, Function onPressed) {
    return TextButton(
      child: Text(text),
      onPressed: onPressed,
    );
  }

  Widget _loginTextInput(String hintText, IconData icon, TextEditingController textController, {bool isPassword: false, FormFieldValidator<String> validator}) {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(icon),
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
      obscureText: isPassword,
      controller: textController,
      validator: validator,
      maxLines: 1
    );
  }

  Widget _loginSubmit(String buttonText, IconData icon, Function onSubmit) {
    return TextButton(
      onPressed: onSubmit,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget> [
          Icon(icon),
          Text(buttonText, style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

}

class _LoginAlert extends StatefulWidget {

  final FirebaseController _fbController;
  final String email;
  final String username;
  final String password;
  final bool isSignIn;

  const _LoginAlert(this._fbController, this.isSignIn, this.email, this.password, {this.username : ""});

  void action(FirebaseListener listener) => this.isSignIn ?
    this._fbController.login(email, password, listener) : this._fbController.register(email, username, password, listener);

  @override
  State<StatefulWidget> createState() => _LoginAlertState(this.isSignIn);

}

class _LoginAlertState extends State<_LoginAlert> implements FirebaseListener {

  List<Widget> _activeWidgets;
  final bool _isSignIn;


  _LoginAlertState(this._isSignIn);

  @override
  void initState() {
    this._activeWidgets = [
      CircularProgressIndicator(),
      Text(this._isSignIn ? "Logging in..." : "Registering...")
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AlertDialog(
        content: Column(
          children: _activeWidgets,
        ),
      ),
    );
  }

  Widget _alertButton(String buttonText, Function onPressed) {
    return TextButton(
      child: Text(buttonText),
      onPressed: onPressed
    );
  }

  @override
  void onLoginIncorrect() {
    setState( () {
      this._activeWidgets = [Text("Credentials don't match"), _alertButton("Go Back", () { Navigator.of(context).pop(); })];
    });
  }

  @override
  void onLoginSuccess() {
    // TODO: implement onLoginSuccess
  }

  @override
  void onRegisterDuplicate() {
    setState( () {
      this._activeWidgets = [Text("This email already exists"), _alertButton("Go Back", () { Navigator.of(context).pop(); })];
    });
  }

  @override
  void onRegisterSuccess() {
    setState( () {
      this._activeWidgets = [Text("This email already exists"),
        _alertButton("Go Back", () {
          Navigator.of(context).pop();
        })];
    });
  }

}