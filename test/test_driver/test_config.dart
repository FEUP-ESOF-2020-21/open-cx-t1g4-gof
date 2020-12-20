import 'dart:async';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';
import 'steps/test_steps.dart';

Future<void> main() {
  final config = FlutterTestConfiguration()
    ..defaultTimeout = new Duration(seconds: 50)
    ..features = [Glob(r"test/test_driver/features/Login.feature")]
    ..reporters = [ProgressReporter()]
    ..stepDefinitions = [CheckGivenWidgets(), FillFormField(), ClickLoginButton()]
    ..restartAppBetweenScenarios = true
    ..targetAppPath = "test/test_driver/app.dart"
    ..exitAfterTestRun = true;

  return GherkinRunner().execute(config);
}
