import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SliderWithLabel extends StatefulWidget {
  const SliderWithLabel({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.badIcon,
    required this.badLabel,
    required this.goodIcon,
    required this.goodLabel
  });
  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  final IconData badIcon, goodIcon;
  final String badLabel, goodLabel;

  @override
  // ignore: library_private_types_in_public_api
  _SliderWithLabelState createState() => _SliderWithLabelState();
}

class _SliderWithLabelState extends State<SliderWithLabel> {
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: Text(widget.label, style: textTheme.labelLarge),
        ),
        Slider(
          value: widget.value,
          min: 1,
          max: 5,
          divisions: 4,
          onChanged: widget.onChanged,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    widget.badIcon,
                    size: 16,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    widget.badLabel,
                    style: textTheme.labelMedium,
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(
                    widget.goodIcon,
                    size: 16,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    widget.goodLabel,
                    style: textTheme.labelMedium,
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddEntryScreenState createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  double moodValue = 3.0; // Initialize with a default value
  double energyValue = 3.0;
  double stressValue = 3.0;
  double productivityValue = 3.0;
  double gratefulnessValue = 3.0;
  double anxiousnessValue = 3.0;
  double sleepQualityValue = 3.0;
  double sportActivityValue = 3.0;
  String diaryEntry = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Entry'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SliderWithLabel(
                  label: 'Mood',
                  value: moodValue,
                  onChanged: (double newValue) {
                    setState(() {
                      moodValue = newValue;
                    });
                  },
                  badIcon: MdiIcons.emoticonSadOutline,
                  badLabel: 'Terrible',
                  goodIcon: MdiIcons.emoticonHappyOutline,
                  goodLabel: 'Fantastic',
                ),
              ],
            ),
            // Add similar sliders for other values here

            const SizedBox(height: 20.0),

            const Text('Diary Entry'),
            TextField(
              maxLines: 4,
              onChanged: (String text) {
                setState(() {
                  diaryEntry = text;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Write your thoughts here...',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20.0),

            ElevatedButton(
              onPressed: () {
                // Save the entry with all the values (mood, energy, etc.) and diaryEntry
                // You can implement the saving logic here
                // Don't forget to include a timestamp for the entry
                // After saving, you can navigate back to the previous screen or home screen
              },
              child: const Text('Save Entry'),
            ),
          ],
        ),
      ),
    );
  }
}
