import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/logic/handlers/section_36_handler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Test All Saved Reports For Crashes', () async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({}); // wait, this mocks it! We want real data.
  });
}
