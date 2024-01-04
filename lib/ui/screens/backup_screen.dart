import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../cubit/theme_cubit.dart';

class BackupScreen extends StatelessWidget {
  const BackupScreen({super.key});

  Future<String> exportData() async {
    var myBox = await Hive.openBox('myBox');
    String backupData = myBox.toMap().toString();

    return backupData;
  }

  Future<void> pickFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      // Handle the picked file (result.files.first)
      debugPrint(
          'File picked: ${result.files.first.name} ${result.files.first.size}');
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
                    onTap: () => <void>{debugPrint('export')},
                    leading: const Icon(Icons.backup_outlined)),
              ]),
        ));
  }
}

ThemeMode stringToThemeMode(String string) {
  debugPrint(string);
  if (string == 'system') {
    return ThemeMode.system;
  } else if (string == 'dark') {
    return ThemeMode.dark;
  } else if (string == 'light') {
    return ThemeMode.light;
  }
  return ThemeMode.system;
}

String themeModeToString(ThemeMode themeMode) {
  switch (themeMode) {
    case ThemeMode.system:
      return 'system';
    case ThemeMode.dark:
      return 'dark';
    case ThemeMode.light:
      return 'light'; // Default to system if it's not one of the known modes.
  }
}

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeModeState>(
      // ignore: always_specify_types
      builder: (BuildContext context, ThemeModeState state) {
        // ignore: always_specify_types
        return SegmentedButton(
          segments: <ButtonSegment<String>>[
            // ignore: always_specify_types
            ButtonSegment(value: 'system', icon: Icon(MdiIcons.brightnessAuto)),
            // ignore: always_specify_types
            ButtonSegment(value: 'light', icon: Icon(MdiIcons.brightness6)),
            // ignore: always_specify_types
            ButtonSegment(value: 'dark', icon: Icon(MdiIcons.brightness4)),
            // ignore: always_specify_types
            ButtonSegment(value: 'auto', icon: Icon(MdiIcons.themeLightDark)),
          ],
          selected: <String>{
            themeModeToString(state.themeMode ?? ThemeMode.system)
          },
          onSelectionChanged: (Set<Object?> p0) =>
              BlocProvider.of<ThemeCubit>(context).getTheme(ThemeModeState(
                  themeMode: stringToThemeMode(p0.first.toString()))),
        );
      },
    );
  }
}
