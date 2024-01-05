import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:share_plus/share_plus.dart';

import 'add_screen.dart';

class BackupScreen extends StatelessWidget {
  const BackupScreen({super.key});

  // Future<String> exportData() async {
  //   // ignore: strict_raw_type, always_specify_types

  //   final String backupData = myBox.values.toList().toString();
  //   myBox.close();

  //   return backupData;
  // }

  Future<void> pickFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles();

    final Box<EntryModel> box = await Hive.openBox('entry_box');
    final String? boxPath = box.path;
    await box.close();

    if (result != null && boxPath != null && !box.isOpen) {
      // Handle the picked file (result.files.first)
      debugPrint(
          'File picked: ${result.files.first.name} ${result.files.first.size}');

      final String backupPath = result.files.first.path!;

      try {
        File(backupPath).copy(boxPath);
      } finally {
        final Box<EntryModel> box = await Hive.openBox('entry_box');
        box.close();
      }
    } else {
      // User canceled the picker
      debugPrint('User canceled file picking');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Theme.of(context).colorScheme.background,
        child: Scaffold(
          // ignore: always_specify_types
          appBar: AppBar(title: Text(tr('settings.backup'))),
          body: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const BouncingScrollPhysics(),
              children: <Widget>[
                ListTile(
                    title: Text(tr('backup_screen.import')),
                    subtitle: Text(tr('backup_screen.import_warning')),
                    onTap: () => <void>{pickFile()},
                    leading: const Icon(Icons.settings_backup_restore)),
                ListTile(
                    title: Text(tr('backup_screen.export')),
                    onTap: () async {
                      final Box<EntryModel> myBox =
                          await Hive.openBox('entry_box');

                      // Share the exported data using the share package
                      if (myBox.path != null) {
                        Share.shareXFiles(
                          <XFile>[XFile(myBox.path ?? '')],
                          subject: 'My App Data Backup',
                        );
                      }
                    },
                    leading: const Icon(Icons.backup_outlined)),
              ]),
        ));
  }
}
