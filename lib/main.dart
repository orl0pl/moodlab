import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:hive/hive.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'config/theme.dart';
import 'cubit/theme_cubit.dart';
import 'managers/language_manager.dart';
import 'ui/screens/add_screen.dart';
import 'ui/screens/language_screen.dart';
import 'ui/screens/name_screen.dart';
import 'ui/screens/settings_screen.dart';
import 'ui/screens/skeleton_screen.dart';

/// Try using const constructors as much as possible!

void main() async {
  /// Initialize packages
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  if (Platform.isAndroid) {
    await FlutterDisplayMode.setHighRefreshRate();
  }
  final Directory tmpDir = await getApplicationDocumentsDirectory();//await getTemporaryDirectory();
  debugPrint(tmpDir.path);
  Hive.init(tmpDir.path);
  Hive.registerAdapter(EntryModelAdapter());
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: tmpDir,
  );

  final dynamic savedLanguage = await LanguageManager.getLanguage();

  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: const <Locale>[
        Locale('en'),
        Locale('pl'),
      ],
      fallbackLocale: const Locale('en'),
      useFallbackTranslations: true,
      startLocale: savedLanguage != null ? Locale(savedLanguage.toString()) : null,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeCubit>(
      create: (BuildContext context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeModeState>(
        builder: (BuildContext context, ThemeModeState state) {
          return DynamicColorBuilder(
            builder: (ColorScheme? lightColorScheme, ColorScheme? darkColorScheme) {
              return MaterialApp(
                /// Localization is not available for the title.
                title: 'Flutter Production Boilerplate',
              
                /// Theme stuff
                theme: ThemeData.from(colorScheme: lightColorScheme ?? defaultLightColorScheme),
                darkTheme: ThemeData.from(colorScheme: darkColorScheme ?? defaultDarkColorScheme),
                themeMode: state.themeMode,
              
                /// Localization stuff
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                
                //home: const SkeletonScreen(),
                initialRoute: 'skeleton_screen',
                // ignore: prefer_const_literals_to_create_immutables
                routes: <String, WidgetBuilder>{
                  // ignore: prefer_const_constructors
                  'settings': (BuildContext context)=>SettingsScreen(),
                  // ignore: prefer_const_constructors
                  'skeleton_screen': (BuildContext context)=>SkeletonScreen(),
                  'name_screen': (BuildContext context)=>const NameScreen(),
                  'add_screen': (BuildContext context)=>const AddEntryScreen(),
                  'language_screen':(BuildContext context) => const LanguageSelectionScreen(),
                },
                
              );
            }
          );
        },
      ),
    );
  }
}
