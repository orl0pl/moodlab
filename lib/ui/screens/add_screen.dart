import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EntryModelAdapter extends TypeAdapter<EntryModel> {
  @override
  final int typeId =
      0; // Use a unique integer for each type you're serializing.

  @override
  EntryModel read(BinaryReader reader) {
    return EntryModel(
      reader.readDouble(),
      reader.readDouble(),
      reader.readDouble(),
      reader.readDouble(),
      reader.readDouble(),
      reader.readString(),
      reader.readDouble(),
      reader.readDouble(),
      reader.readDouble(),
      reader.readString(),
      reader.readString(),
      DateTime.fromMillisecondsSinceEpoch(reader.readInt32() * 1000),
    );
  }

  @override
  void write(BinaryWriter writer, EntryModel obj) {
    writer.writeDouble(obj.moodValue);
    writer.writeDouble(obj.energyValue);
    writer.writeDouble(obj.stressValue);
    writer.writeDouble(obj.stressValue);
    writer.writeDouble(obj.stressValue);
    writer.writeString(obj.diaryEntry);
    writer.writeDouble(obj.gratefulnessValue);
    writer.writeDouble(obj.sleepQualityValue);
    writer.writeDouble(obj.sportActivityValue);
    // TODO(orl0pl): dodaj te żeczy
    writer.writeString(obj.activities);
    writer.writeString(obj.title);
    writer.writeInt32(
        obj.timestamp.millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond);
  }
}

// EntryModel definition
@HiveType(typeId: 0)
class EntryModel extends HiveObject {
  // Define other fields as needed.

  EntryModel(
      this.moodValue,
      this.energyValue,
      this.stressValue,
      this.productivityValue,
      this.anxiousnessValue,
      this.diaryEntry,
      this.gratefulnessValue,
      this.sleepQualityValue,
      this.sportActivityValue,
      this.activities,
      this.title,
      this.timestamp);
  @HiveField(0)
  double moodValue; // Initialize with a default value
  @HiveField(1)
  double energyValue;
  @HiveField(2)
  double stressValue;
  @HiveField(3)
  double productivityValue;
  @HiveField(4)
  double gratefulnessValue;
  @HiveField(5)
  double anxiousnessValue;
  @HiveField(6)
  double sleepQualityValue;
  @HiveField(7)
  double sportActivityValue;
  @HiveField(8)
  String diaryEntry;
  @HiveField(9)
  String activities;
  @HiveField(10)
  String title;
  @HiveField(11)
  DateTime timestamp;
}

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
  String activities = '';
  String title = '';

  Future<void> _openHiveBox() async {
    final Box<EntryModel> box = await Hive.openBox<EntryModel>(
        'entry_box'); // Replace 'entry_box' with your desired box name.
    // Save your data to Hive here.
    final EntryModel entry = EntryModel(
        moodValue,
        energyValue,
        stressValue,
        productivityValue,
        anxiousnessValue,
        diaryEntry,
        gratefulnessValue,
        sleepQualityValue,
        sportActivityValue,
        activities,
        title,
        DateTime.now());
    await box.add(entry);
    box.close(); // Don't forget to close the box when you're done.
  }

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
                  TextField(
                    onChanged: (String value) => <void>{
                      setState(
                        () {
                          title = value;
                        },
                      )
                    },
                  ),
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
                  TextField(
                      onChanged: (String value) => <void>{
                            setState(
                              () {
                                activities = value;
                              },
                            )
                          },
                      decoration: const InputDecoration(
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
      floatingActionButton: FloatingActionButton(
          onPressed: () => <void>{
                _openHiveBox(),
                debugPrint('Data saved!'),
                Navigator.pop(context)
              },
          tooltip: 'Save',
          child: const Icon(Icons.done)),
    );
  }
}
