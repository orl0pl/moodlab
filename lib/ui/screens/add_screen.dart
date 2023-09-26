import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SliderWithLabel extends StatefulWidget {
  const SliderWithLabel(
      {super.key,
      required this.label,
      required this.value,
      required this.onChanged,
      required this.badIcon,
      required this.badLabel,
      required this.goodIcon,
      required this.goodLabel});
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
    final TextTheme textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
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
                  label: tr('sliders.mood.question'),
                  value: moodValue,
                  onChanged: (double newValue) {
                    setState(() {
                      moodValue = newValue;
                    });
                  },
                  badIcon: MdiIcons.emoticonSadOutline,
                  badLabel: tr('sliders.mood.minLabel'),
                  goodIcon: MdiIcons.emoticonHappyOutline,
                  goodLabel: tr('sliders.mood.maxLabel'),
                ),
                const SizedBox(
                  height: 36,
                ),
                SliderWithLabel(
                  label: tr('sliders.energy.question'),
                  value: energyValue,
                  onChanged: (double newValue) {
                    setState(() {
                      energyValue = newValue;
                    });
                  },
                  badIcon: MdiIcons.brightness3,
                  badLabel: tr('sliders.energy.minLabel'),
                  goodIcon: MdiIcons.whiteBalanceSunny,
                  goodLabel: tr('sliders.energy.maxLabel'),
                ),
                const SizedBox(
                  height: 36,
                ),
                SliderWithLabel(
                  label: tr('sliders.stress.question'),
                  value: stressValue,
                  onChanged: (double newValue) {
                    setState(() {
                      stressValue = newValue;
                    });
                  },
                  badIcon: MdiIcons.waveform,
                  badLabel: tr('sliders.stress.maxLabel'),
                  goodIcon: MdiIcons.wave,
                  goodLabel: tr('sliders.stress.minLabel'),
                ),
                const SizedBox(
                  height: 36,
                ),
                SliderWithLabel(
                  label: tr('sliders.productivity.question'),
                  value: productivityValue,
                  onChanged: (double newValue) {
                    setState(() {
                      productivityValue = newValue;
                    });
                  },
                  badIcon: MdiIcons.closeCircleOutline,
                  badLabel: tr('sliders.productivity.minLabel'),
                  goodIcon: MdiIcons.checkCircle,
                  goodLabel: tr('sliders.productivity.maxLabel'),
                ),
                const SizedBox(
                  height: 36,
                ),
                SliderWithLabel(
                  label: tr('sliders.gratefulness.question'),
                  value: gratefulnessValue,
                  onChanged: (double newValue) {
                    setState(() {
                      gratefulnessValue = newValue;
                    });
                  },
                  badIcon: MdiIcons.cancel,
                  badLabel: tr('sliders.gratefulness.minLabel'),
                  goodIcon: MdiIcons.emoticonCool,
                  goodLabel: tr('sliders.gratefulness.maxLabel'),
                ),
                const SizedBox(
                  height: 36,
                ),
                SliderWithLabel(
                  label: tr('sliders.anxiousness.question'),
                  value: anxiousnessValue,
                  onChanged: (double newValue) {
                    setState(() {
                      anxiousnessValue = newValue;
                    });
                  },
                  badIcon: MdiIcons.emoticonSad,
                  badLabel: tr('sliders.anxiousness.maxLabel'),
                  goodIcon: MdiIcons.emoticonNeutral,
                  goodLabel: tr('sliders.anxiousness.minLabel'),
                ),
                const SizedBox(
                  height: 36,
                ),
                SliderWithLabel(
                  label: tr('sliders.sleepQuality.question'),
                  value: sleepQualityValue,
                  onChanged: (double newValue) {
                    setState(() {
                      sleepQualityValue = newValue;
                    });
                  },
                  badIcon: MdiIcons.sleepOff,
                  badLabel: tr('sliders.sleepQuality.minLabel'),
                  goodIcon: MdiIcons.sleep,
                  goodLabel: tr('sliders.sleepQuality.maxLabel'),
                ),
                const SizedBox(
                  height: 36,
                ),
                SliderWithLabel(
                  label: tr('sliders.sportActivity.question'),
                  value: sportActivityValue,
                  onChanged: (double newValue) {
                    setState(() {
                      sportActivityValue = newValue;
                    });
                  },
                  badIcon: MdiIcons.sofaSingleOutline,
                  badLabel: tr('sliders.sportActivity.minLabel'),
                  goodIcon: MdiIcons.runFast,
                  goodLabel: tr('sliders.sportActivity.maxLabel'),
                ),
                const SizedBox(height: 36.0),
              ],
            ),
            // Add similar sliders for other values here
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('How you will name this entry?',
                      style: textTheme.labelLarge),
                  const TextField(),
                ],
              ),
            ),
            const SizedBox(height: 36.0),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('What you were doing snice last entry?',
                      style: textTheme.labelLarge),
                  const TextField(
                      decoration: InputDecoration(
                          label: Text('seperate values with comma'),
                          floatingLabelBehavior: FloatingLabelBehavior.always)),
                ],
              ),
            ),
            const SizedBox(height: 36.0),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('You can write something below',
                      style: textTheme.labelLarge),
                  const SizedBox(height: 16.0),
                  TextField(
                    maxLines: null,
                    onChanged: (String text) {
                      setState(() {
                        diaryEntry = text;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36.0),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: ()=><void>{debugPrint('implement!'), Navigator.pop(context)}, tooltip: 'Save', child: const Icon(Icons.done)),
    );
  }
}
