import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:inquirescape/firebase/FirebaseController.dart';
import 'package:inquirescape/firebase/FirebaseListener.dart';
import 'package:inquirescape/pages/Validators.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _loginPage = true; // If true -> display Login; If false -> Display Register
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passowrdController = TextEditingController();
  TextEditingController _registerEmailController = TextEditingController();
  TextEditingController _registerUsernameController = TextEditingController();
  TextEditingController _registerPassowrdController = TextEditingController();
  TextEditingController _confirmPassowrdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(top: 10.0, bottom: 10.0),
      child: SingleChildScrollView(
        child: _loginPage ? loginPage() : registerPage(),
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
          margin: EdgeInsetsDirectional.only(top: 20.0, start: 20.0, end: 20.0),
          alignment: Alignment.centerLeft,
          child: _loginTextInput('Enter your email', Icons.email, _emailController,
              keyboardType: TextInputType.emailAddress, inputAction: TextInputAction.next),
        ),
        Container(
          margin: EdgeInsetsDirectional.only(top: 20.0, start: 20.0, end: 20.0),
          alignment: Alignment.centerLeft,
          child: _loginTextInput('Enter your password', Icons.vpn_key, _passowrdController,
              isPassword: true, inputAction: TextInputAction.done),
        ),
        Container(
          margin: EdgeInsetsDirectional.only(top: 10.0, start: 20.0, end: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _switchStateButton("Create an account?", () => setState(() => _loginPage = false)),
              _switchStateButton("Forgot password?", () {}),
            ],
          ),
        ),
        Container(
          child: _loginSubmit("Login", Icons.login, () {
            showDialog(
                context: context,
                builder: (context) => _LoginAlert(true, _emailController.text, _passowrdController.text));
          }),
        ),
      ],
    );
  }

  Widget registerPage() {
    return Column(
      children: <Widget>[
        Icon(
          Icons.account_circle_rounded,
          size: 200.0,
        ),
        Container(
            margin: EdgeInsetsDirectional.only(top: 20.0, start: 20.0, end: 20.0),
            alignment: Alignment.centerLeft,
            child: _loginTextInput('Enter your email', Icons.email, _registerEmailController,
                validator: Validators.emailValidator(), keyboardType: TextInputType.emailAddress)),
        Container(
          margin: EdgeInsetsDirectional.only(top: 20.0, start: 20.0, end: 20.0),
          alignment: Alignment.centerLeft,
          child: _loginTextInput('Enter your username', Icons.person, _registerUsernameController,
              validator: Validators.usernameValidator()),
        ),
        Container(
          margin: EdgeInsetsDirectional.only(top: 20.0, start: 20.0, end: 20.0),
          alignment: Alignment.centerLeft,
          child: _loginTextInput('Enter your password', Icons.vpn_key, _registerPassowrdController,
              isPassword: true, validator: Validators.passwordValidator()),
        ),
        Container(
          margin: EdgeInsetsDirectional.only(top: 20.0, start: 20.0, end: 20.0),
          alignment: Alignment.centerLeft,
          child: _loginTextInput('Confirm your password', Icons.vpn_key, _confirmPassowrdController,
              isPassword: true, validator: Validators.confirmPasswordValidator(_passowrdController)),
        ),
        Container(
          margin: EdgeInsetsDirectional.only(top: 10.0, start: 20.0, end: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _switchStateButton("Already have an account?", () => setState(() => _loginPage = true)),
            ],
          ),
        ),
        Container(
          child: _loginSubmit("Register", Icons.login, () {
            showDialog(
                context: context,
                builder: (context) => _LoginAlert(
                    false, _registerEmailController.text, _registerPassowrdController.text,
                    username: _registerUsernameController.text));
          }),
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

  Widget _loginTextInput(String hintText, IconData icon, TextEditingController textController,
      {bool isPassword: false,
      FormFieldValidator<String> validator,
      TextInputType keyboardType = TextInputType.text,
      TextInputAction inputAction}) {
    return TextFormField(
        keyboardType: keyboardType,
        textInputAction: inputAction,
        decoration: InputDecoration(
          icon: Icon(icon),
          hintText: hintText,
          border: const OutlineInputBorder(),
        ),
        obscureText: isPassword,
        controller: textController,
        validator: validator,
        maxLines: 1);
  }

  Widget _loginSubmit(String buttonText, IconData icon, Function onSubmit) {
    return TextButton(
      onPressed: onSubmit,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon),
          Text(buttonText, style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}

class _LoginAlert extends StatefulWidget {
  final String email;
  final String username;
  final String password;
  final bool isSignIn;

  const _LoginAlert(this.isSignIn, this.email, this.password, {this.username: ""});

  void action(FirebaseListener listener) => this.isSignIn
      ? FirebaseController.login(email, password, listener)
      : FirebaseController.register(email, username, password, listener);

  @override
  State<StatefulWidget> createState() => _LoginAlertState(this.isSignIn);
}

class _LoginAlertState extends State<_LoginAlert> implements FirebaseListener {
  List<Widget> _activeWidgets;
  final bool _isSignIn;

  _LoginAlertState(this._isSignIn);

  @override
  void initState() {
    super.initState();

    FirebaseController.subscribeListener(this);
    this._activeWidgets = [CircularProgressIndicator(), Text(this._isSignIn ? "Logging in..." : "Registering...")];
    this.widget.action(this);
  }

  @override
  void dispose() {
    super.dispose();

    FirebaseController.unsubscribeListener(this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: _activeWidgets,
        ),
      ),
    );
  }

  Widget _alertButton(String buttonText, Function onPressed) {
    return TextButton(child: Text(buttonText), onPressed: onPressed);
  }

  @override
  void onLoginIncorrect() {
    if (mounted) {
      setState(() {
        this._activeWidgets = [
          Text("Credentials don't match"),
          _alertButton("Go Back", () {
            Navigator.pop(context);
          })
        ];
      });
    }
  }

  @override
  void onLoginSuccess() {}

  @override
  void onRegisterDuplicate() {
    if (mounted) {
      setState(() {
        this._activeWidgets = [
          Text("This email already exists"),
          _alertButton("Go Back", () {
            Navigator.pop(context);
          })
        ];
      });
    }
  }

  @override
  void onRegisterSuccess() {}

  @override
  void onDataChanged() {}

  @override
  void onLogout() {}
}
