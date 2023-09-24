import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../cubit/theme_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    return Material(
        color: Theme.of(context).colorScheme.background,
        child: Scaffold(
          // ignore: always_specify_types
          appBar: AppBar(title: const Text('Settings')),
          body: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const BouncingScrollPhysics(),
              children: <Widget>[
                const ListTile(
                    title: Text('Theme'),
                    subtitle: ThemeSelector(),
                    leading: Icon(Icons.color_lens)),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 8),
                  child: Text(
                    'User',
                    style: textTheme.titleSmall,
                  ),
                ),
                ListTile(
                    title: const Text('Name'),
                    subtitle: const Text('Change name'),
                    onTap: ()=><Future<Object?>>{Navigator.pushNamed(context, 'name_screen')},
                    leading: const Icon(Icons.account_circle)),
                ListTile(
                    title: const Text('Language'),
                    subtitle: const Text('Change language'),
                    onTap: ()=><Future<Object?>>{Navigator.pushNamed(context, 'language_screen')},
                    leading: const Icon(Icons.language)),
                const SizedBox(
                  height: 4,
                ),
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
