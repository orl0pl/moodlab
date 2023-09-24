import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../boxes/user_box.dart';



class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

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
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            // Display the username
            FutureBuilder<String?>(
              future: userBox.getUserName(),
              builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
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
              children: <Widget>[
                for (int i = 0; i < 10; i++)
                  EntryCard(
                    textTheme: textTheme,
                    onTap: () => <void>{debugPrint('Tapped $i')},
                    time: formatDate(DateTime.now().subtract(const Duration(hours: 16))),
                    title: '$i Sus Day',
                    body: "This $i's day was very sus",
                  )
              ],
            )
          ],
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
  const EntryCard(
      {super.key,
      required this.textTheme,
      required this.onTap,
      required this.time,
      required this.title,
      required this.body});

  final TextTheme textTheme;
  final GestureTapCallback onTap;
  final String time, title, body;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  time,
                  style: textTheme.labelMedium,
                ),
                Text(
                  title,
                  style: textTheme.titleLarge,
                ),
                Text(
                  body,
                  style: textTheme.bodyMedium,
                )
              ]),
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
  const GreetingsHeader(
      {super.key,
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
            onPressed: () =><Future<Object?>>{
              Navigator.pushNamed(context, 'settings')
                },
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
