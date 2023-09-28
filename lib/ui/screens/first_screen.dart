// ignore_for_file: library_private_types_in_public_api

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../boxes/user_box.dart';
import 'add_screen.dart';
import 'entry_screen.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  // Define a list to store the retrieved entries.
  List<EntryModel> entries = <EntryModel>[];

  @override
  void initState() {
    super.initState();
    _openHiveBox();
  }

  // Open the Hive box and retrieve entries.
  Future<void> _openHiveBox() async {
    final Box<EntryModel> box = await Hive.openBox<EntryModel>('entry_box');

    // Retrieve the entries from Hive and store them in the 'entries' list.
    //entries = box.values.toList();

    setState(() {
      entries = box.values.toList();
      entries.sort((EntryModel a, EntryModel b) =>  a.timestamp.compareTo(b.timestamp));
    });
    box.close();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    // Use the UserBox class to get the username
    final UserBox userBox = UserBox();
    return Material(
      color: Theme.of(context).colorScheme.background,
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => <void>{Navigator.pushNamed(context, 'add_screen')},
          label: const Text('Add entry'),
          icon: const Icon(Icons.edit),
        ),
        body: RefreshIndicator(
          // ignore: always_specify_types
          onRefresh: () => Future.delayed(
              const Duration(milliseconds: 300), () => _openHiveBox()),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics:
                const AlwaysScrollableScrollPhysics(), //BouncingScrollPhysics(),

            children: <Widget>[
              // Display the username
              FutureBuilder<String?>(
                future: userBox.getUserName(),
                builder:
                    (BuildContext context, AsyncSnapshot<String?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // While waiting for the data to load, you can display a loading indicator
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // Handle error here if needed
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    // Display the username if it's available
                    return GreetingsHeader(
                      textTheme: textTheme,
                      name: snapshot.data!,
                    );
                  } else {
                    // If no data is available, you can provide a default message
                    return GreetingsHeader(
                      textTheme: textTheme,
                      name: 'Guest', // Default message
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              IconWithLabel(
                textTheme: textTheme,
                icon: MdiIcons.creationOutline,
                label: tr('analitics_summary'),
              ),
              const SizedBox(height: 16),
              EmotionTrendsSummary(textTheme: textTheme),
              const SizedBox(height: 16),
              IconWithLabel(
                textTheme: textTheme,
                icon: MdiIcons.history,
                label: tr('recent_entries'),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: entries.isEmpty
                    ? <Widget>[const Text("Let's start by adding entry")]
                    : entries
                        
                        .map((EntryModel e) =>
                            EntryCard(textTheme: textTheme, entry: e))
                        .toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

String formatDate(DateTime date) {
  final DateTime now = DateTime.now();
  final DateFormat hMformatter = DateFormat('H:MM');
  final DateFormat formatter = DateFormat('d MMMM');
  final DateFormat yFormatter = DateFormat('d MMMM, y');

  if (date.year == now.year) {
    if (date.month == now.month && date.day == now.day) {
      return tr('today', args: <String>[hMformatter.format(date)]);
    } else if (date.isBefore(now) &&
        date.isAfter(now.subtract(const Duration(days: 1)))) {
      return tr('yesterday', args: <String>[hMformatter.format(date)]);
    } else {
      return formatter.format(date);
    }
  } else {
    return yFormatter.format(date);
  }
}

class EntryCard extends StatelessWidget {
  const EntryCard({
    super.key,
    required this.textTheme,
    required this.entry,
  });

  final TextTheme textTheme;
  final EntryModel entry;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          // Handle tap on the entry if needed.
          debugPrint('Tapped entry with title: ${entry.title}');
          Navigator.push(
            context,
            // ignore: always_specify_types
            MaterialPageRoute(
              builder: (BuildContext context) => EntryViewScreen(
                  entryKey: entry.key as int), // Pass the selected entry's key
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                formatDate(entry.timestamp), // Display the timestamp
                style: textTheme.labelMedium,
              ),
              Text(
                entry.title,
                style: textTheme.titleLarge,
              ),
              Text(
                entry.diaryEntry,
                style: textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IconWithLabel extends StatelessWidget {
  const IconWithLabel(
      {super.key,
      required this.textTheme,
      required this.icon,
      required this.label});

  final TextTheme textTheme;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Icon(icon, size: 20),
      const SizedBox(width: 4),
      Text(
        label,
        style: textTheme.titleSmall,
      )
    ]);
  }
}

class GreetingsHeader extends StatelessWidget {
  const GreetingsHeader({
    super.key,
    required this.textTheme,
    required this.name,
  });

  final TextTheme textTheme;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Hi $name!', style: textTheme.headlineLarge),
        IconButton.filledTonal(
            onPressed: () =>
                <Future<Object?>>{Navigator.pushNamed(context, 'settings')},
            icon: const Icon(Icons.account_circle_outlined))
      ],
    );
  }
}

class EmotionTrendsSummary extends StatelessWidget {
  const EmotionTrendsSummary({
    super.key,
    required this.textTheme,
  });

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          color: Theme.of(context).colorScheme.primaryContainer),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              const Icon(Icons.trending_up),
              const SizedBox(width: 8),
              Text(
                tr('emotion_trend'),
                style: Theme.of(context)
                    .textTheme
                    .apply(
                        displayColor:
                            Theme.of(context).colorScheme.onPrimaryContainer)
                    .labelLarge,
              )
            ]),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Icon(MdiIcons.arrowUpThick),
                const SizedBox(width: 8),
                Text(
                  'Mood',
                  style: textTheme.bodyLarge,
                ),
                const Spacer(),
                Text(
                  '+69% last week',
                  style: textTheme.labelMedium,
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: <Widget>[
                Icon(MdiIcons.arrowUpThick),
                const SizedBox(width: 8),
                Text(
                  'Energy',
                  style: textTheme.bodyLarge,
                ),
                const Spacer(),
                Text(
                  '+9% last week',
                  style: textTheme.labelMedium,
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: <Widget>[
                Icon(MdiIcons.arrowDownThick),
                const SizedBox(width: 8),
                Text(
                  'Producivity',
                  style: textTheme.bodyLarge,
                ),
                const Spacer(),
                Text(
                  '-19% last week',
                  style: textTheme.labelMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
