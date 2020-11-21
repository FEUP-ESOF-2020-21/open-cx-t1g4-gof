import 'package:flutter/material.dart';

class Validators {
  static const String _regexUsername = r"^(?=.*[\w])(?=.{1,}[^\d]).{3,28}$";
  static const String _regexEmail =
      r"^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
  static const String _regexPassword = r"^(?=.*\d)(?=.*[\w])(?=.{1,}[^\d]).{6,20}$";

  static FormFieldValidator<String> usernameValidator() {
    return (String value) {
      if (RegExp(_regexUsername).hasMatch(value)) {
        return null;
      }
      return "Username must contain at least one letter and be between 3 and 28 characters";
    };
  }

  static FormFieldValidator<String> emailValidator() {
    return (String value) {
      if (RegExp(_regexEmail).hasMatch(value)) {
        return null;
      }
      return "Invalid email";
    };
  }

  static FormFieldValidator<String> passwordValidator() {
    return (String value) {
      if (RegExp(_regexPassword).hasMatch(value)) {
        return null;
      }
      return "Password must contain at least one letter, one number and be between 6 and 20 characters";
    };
  }

  static FormFieldValidator<String> confirmPasswordValidator(TextEditingController passwordController) {
    return (String value) {
      if (value != passwordController.text) return "Passwords must match";
      return null;
    };
  }
}
