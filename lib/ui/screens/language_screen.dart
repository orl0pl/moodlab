import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../managers/language_manager.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('language_screen.title')),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('English'),
            onTap: () {
              // Change the app's language to English (en) and save it
              LanguageManager.changeLanguage(context, 'en');
              LanguageManager.saveLanguage('en');
            },
          ),
          ListTile(
            title: const Text('Polish'),
            onTap: () {
              // Change the app's language to Polish (pl) and save it
              LanguageManager.changeLanguage(context, 'pl');
              LanguageManager.saveLanguage('pl');
            },
          ),
          // Add more language options as needed
        ],
      ),
    );
  }
}
