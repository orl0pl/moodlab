// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'add_screen.dart';
import 'edit_screen.dart';
import 'first_screen.dart';

class EntryViewScreen extends StatefulWidget {
  const EntryViewScreen(
      {super.key,
      required this.entryKey}); // Pass the key of the selected entry to this screen

  final int entryKey;

  @override
  _EntryViewScreenState createState() => _EntryViewScreenState();
}

class _EntryViewScreenState extends State<EntryViewScreen> {
  EntryModel? entry; // Declare a variable to hold the entry
  @override
  void initState() {
    super.initState();
    _getEntry();
  }

  Future<void> _getEntry() async {
    // ignore: prefer_final_locals
    Box<EntryModel> box =
        await Hive.openBox<EntryModel>('entry_box'); // Open the Hive box
    
    // ignore: cast_nullable_to_non_nullable
    entry =
        // ignore: cast_nullable_to_non_nullable
        box.get(widget.entryKey) as EntryModel;
         // Retrieve the entry by its key
    if(box.isOpen){
      box.close();
    }
     // Close the Hive box
    setState(() {}); // Trigger a rebuild to display the entry
  }

  Future<void> _deleteDialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        void delete() {
          int count = 0;
          Hive.openBox<EntryModel>('entry_box')
              .then((Box<EntryModel> box) => <void>{
                    box.get(widget.entryKey)?.delete(),
                    box.close(),
                    Navigator.of(context).popUntil((_) => count++ >= 2),
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Entry deleted')),
                    ),
                  });
        }

        return AlertDialog(
          title: const Text('Delete this entry?'),
          content: const Text(
            'Deleting this entry will wipe this entry from existence permanently.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FilledButton(
              onPressed: delete,
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;


    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              onPressed: () =>
                  <void>{debugPrint('delete'), _deleteDialogBuilder(context)},
              icon: const Icon(Icons.delete_outline)),
          IconButton(
              onPressed: () => <void>{
                    debugPrint('edit'),
                    Navigator.push(
                      context,
                      // ignore: always_specify_types
                      MaterialPageRoute(
                        builder: (BuildContext context) => EditEntryScreen(
                            entryKey: entry!.key
                                as int), // Pass the selected entry's key
                      ),
                      // ignore: always_specify_types
                    ).then((value) => Future.delayed(
                          const Duration(milliseconds: 300),
                          () => _getEntry(),
                        ))
                  },
              icon: const Icon(Icons.edit)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: entry == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    formatDate(entry!.timestamp),
                    style: textTheme.titleSmall,
                  ),
                  const SizedBox(height: 0.0),
                  Text(
                    entry!.title,
                    style: textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4.0),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: <Widget>[
                      Text('Mood: ${entry!.moodValue.toStringAsPrecision(1)}', style: textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.tertiary), ),
                      const SizedBox(width: 8,),
                      Text('Energy: ${entry!.energyValue.toStringAsPrecision(1)}', style: textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.tertiary), ),
                      const SizedBox(width: 8,),
                      Text('Stress: ${entry!.stressValue.toStringAsPrecision(1)}', style: textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.tertiary), ),
                      const SizedBox(width: 8,),
                      Text('Productivity: ${entry!.productivityValue.toStringAsPrecision(1)}', style: textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.tertiary), ),
                      const SizedBox(width: 8,),
                      Text('Gratefulness: ${entry!.gratefulnessValue.toStringAsPrecision(1)}', style: textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.tertiary), ),
                      const SizedBox(width: 8,),
                      Text('Anxiousness: ${entry!.anxiousnessValue.toStringAsPrecision(1)}', style: textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.tertiary), ),
                      const SizedBox(width: 8,),
                      Text('Sleep quality: ${entry!.sleepQualityValue.toStringAsPrecision(1)}', style: textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.tertiary), ),
                      const SizedBox(width: 8,),
                      Text('Sport activity: ${entry!.sportActivityValue.toStringAsPrecision(1)}', style: textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.tertiary), ),
                    
                    ], ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    entry!.diaryEntry,
                    style: textTheme.bodyLarge,
                  ),
                ],
              ),
      ),
    );
  }
}
