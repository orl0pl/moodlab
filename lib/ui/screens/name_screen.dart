// ignore_for_file: library_private_types_in_public_api, always_specify_types, use_build_context_synchronously

import 'package:flutter/material.dart';

import '../../boxes/user_box.dart';


class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  _NameScreenState createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final TextEditingController _nameController = TextEditingController();
  final UserBox _userBox = UserBox();

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final userName = await _userBox.getUserName();
    if (userName != null) {
      setState(() {
        _nameController.text = userName.toString();
      });
    }
  }

  Future<void> _saveUserName() async {
    final String name = _nameController.text;
    await _userBox.saveUserName(name);
  }

  Future<void> _updateUserName() async {
    final String newName = _nameController.text;
    await _userBox.saveUserName(newName);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Username updated to $newName'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Name'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Enter your new name:'),
            TextField(
              controller: _nameController,
            ),
            ElevatedButton(
              onPressed: _updateUserName, // Use _updateUserName instead of _saveUserName
              child: const Text('Update Name'), // Change the button label
            ),
            ElevatedButton(
              onPressed: _saveUserName, // Keep the save button for initial setup
              child: const Text('Save Name'),
            ),
          ],
        ),
      ),
    );
  }
}
