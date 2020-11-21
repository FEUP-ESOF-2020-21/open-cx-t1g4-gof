import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

class CheckGivenWidgets extends Given2WithWorld<String, String, FlutterWorld> {
  @override
  Future<void> executeStep(String input1, String input2) async {
    // TODO: implement executeStepfinal textinput1 = find.byValueKey(input1);
    final drawerLogOff = find.byValueKey(input1);
    final loginButton = find.byValueKey(input2);
    await FlutterDriverUtils.isPresent(world.driver, drawerLogOff);
    await FlutterDriverUtils.isPresent(world.driver, loginButton);
  }

  @override
// TODO: implement pattern
  RegExp get pattern => RegExp(r"I have {string} and {string}");
}

class ClickLoginButton extends Then1WithWorld<String, FlutterWorld> {
  @override
  Future<void> executeStep(String loginbtn) async {
// TODO: implement executeStep
    final loginfinder = find.byValueKey(loginbtn);
    await FlutterDriverUtils.tap(world.driver, loginfinder);
  }

  @override
  RegExp get pattern => RegExp(r"I tap the {string} element");
}

// class Given_Then_I_end_up_with__LoginPage_ extends Given1<String> {
//   @override
//   RegExp get pattern => RegExp(r'I end up with "LoginPage"');

//   @override
//   Future<void> executeStep(String input1) async {
//     final loginfinder = find.byValueKey('LoginPage');
//     await FlutterDriverUtils.tap(world.driver, loginfinder);
//   }
// }
