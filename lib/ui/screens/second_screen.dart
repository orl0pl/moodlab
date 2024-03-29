import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'add_screen.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  _SecondScreenState();

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

    if (mounted) {
      setState(() {
        entries = box.values.toList();
      });
    }
    debugPrint(entries.map((e) => e.moodValue.toString()).toString());
    box.close();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.background,
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () => Future<void>.delayed(
              const Duration(milliseconds: 300), () => _openHiveBox()),
          child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const AlwaysScrollableScrollPhysics(),
              children: <Widget>[
                const SizedBox(
                  height: 100,
                ),
                Container(
                  height: 300,
                  child: SfCartesianChart(
                    title: ChartTitle(text: tr('analytics.metrics.fixed_graph')),
                    plotAreaBorderWidth: 0,
                    palette: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary
                    ],
                    primaryYAxis: const NumericAxis(
                        // minimum: 1,
                        // maximum: 5,
                        interval: 1,
                        majorTickLines: MajorTickLines(size: 0)),
                    primaryXAxis: const DateTimeAxis(
                      // intervalType: DateTimeIntervalType.days,
                      // dateFormat: DateFormat.yMd(),
                      // majorGridLines: const MajorGridLines(width: 0),
                    ),
                    series: <CartesianSeries<dynamic, dynamic>>[
                      LineSeries<EntryModel, DateTime>(
                        animationDuration: 300,
                        xValueMapper: (EntryModel val, _) => val.timestamp,
                        yValueMapper: (EntryModel val, _) => val.moodValue,
                        dataSource: entries,
                      )
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
