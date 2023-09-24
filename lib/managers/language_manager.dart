// ignore_for_file: strict_raw_type, avoid_classes_with_only_static_members, always_specify_types

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class LanguageManager {
  static const String _boxName = 'languageBox';

  // Save the selected language code
  static Future<void> saveLanguage(String languageCode) async {
    final Box box = await Hive.openBox(_boxName);
    await box.put('language', languageCode);
  }

  // Retrieve the selected language code
  static Future getLanguage() async {
    final Box box = await Hive.openBox(_boxName);
    return box.get('language');
  }

  // Change the app's language
  static void changeLanguage(BuildContext context, String languageCode) {
    context.setLocale(Locale(languageCode));
  }
}
