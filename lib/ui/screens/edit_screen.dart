// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'add_screen.dart';

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

class EditEntryScreen extends StatefulWidget {
  const EditEntryScreen({super.key, required this.entryKey});

  final int entryKey;

  @override
  // ignore: library_private_types_in_public_api
  _EditEntryScreenState createState() => _EditEntryScreenState();
}

class _EditEntryScreenState extends State<EditEntryScreen> {
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

  EntryModel? entry; // Declare a variable to hold the entry
  @override
  void initState() {
    super.initState();
    _getEntry();
  }

  Future<void> _getEntry() async {
    final Box<EntryModel> box =
        await Hive.openBox<EntryModel>('entry_box'); // Open the Hive box
    // ignore: cast_nullable_to_non_nullable
    entry =
        // ignore: cast_nullable_to_non_nullable
        box.get(widget.entryKey) as EntryModel;

    if (entry != null) {
      moodValue = entry!.moodValue;
      energyValue = entry!.energyValue;
      stressValue = entry!.stressValue;
      productivityValue = entry!.productivityValue;
      gratefulnessValue = entry!.gratefulnessValue;
      anxiousnessValue = entry!.anxiousnessValue;
      sleepQualityValue = entry!.sleepQualityValue;
      sportActivityValue = entry!.sportActivityValue;
      diaryEntry = entry!.diaryEntry;
      activities = entry!.activities;
      title = entry!.title;
    } else {
      Navigator.pop(context);
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Not found')));
    }
    box.close(); // Close the Hive box
    setState(() {}); // Trigger a rebuild to display the entry
  }

  Future<void> _openHiveBox() async {
    final Box<EntryModel> box = await Hive.openBox<EntryModel>(
        'entry_box'); // Replace 'entry_box' with your desired box name.
    // Save your data to Hive here.
    // EntryModel(
    //     moodValue,
    //     energyValue,
    //     stressValue,
    //     productivityValue,
    //     anxiousnessValue,
    //     diaryEntry,
    //     gratefulnessValue,
    //     sleepQualityValue,
    //     sportActivityValue,
    //     activities,
    //     title,
    //     DateTime.now());
    debugPrint(widget.entryKey.toString());
    debugPrint(entry!.key.toString());
    debugPrint((entry == null) ? 'tak' : 'nie');
    if (entry != null) {
      final EntryModel? newEntry = box.get(entry!.key);
      newEntry?.moodValue = moodValue;
      newEntry?.energyValue = energyValue;
      newEntry?.stressValue = stressValue;
      newEntry?.productivityValue = productivityValue;
      newEntry?.gratefulnessValue = gratefulnessValue;
      newEntry?.anxiousnessValue = anxiousnessValue;
      newEntry?.sleepQualityValue = sleepQualityValue;
      newEntry?.sportActivityValue = sportActivityValue;
      newEntry?.diaryEntry = diaryEntry;
      newEntry?.activities = activities;
      newEntry?.title = title;

      //final int index = box.values.toList().indexWhere((EntryModel element) => element.key == entry!.key);
      newEntry?.save(); //put(entry!.key, newEntry);
      //box.putAt(index, entry!);
    }
    box.close(); // Don't forget to close the box when you're done.
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Entry'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: entry != null
            ? Column(
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
                        TextFormField(
                          initialValue: entry!.title,
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
                        TextFormField(
                            initialValue: entry!.activities,
                            onChanged: (String value) => <void>{
                                  setState(
                                    () {
                                      activities = value;
                                    },
                                  )
                                },
                            decoration: const InputDecoration(
                                label: Text('seperate values with comma'),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always)),
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
                        TextFormField(
                          initialValue: entry!.diaryEntry,
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
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => <void>{
                _openHiveBox(),
                Navigator.pop(context),
                debugPrint('Data saved!'),
              },
          tooltip: 'Save',
          child: const Icon(Icons.done)),
    );
  }
}
