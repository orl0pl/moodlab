// ignore_for_file: library_private_types_in_public_api, always_specify_types, use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
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
        _nameController.text = userName;
      });
    }
  }


  Future<void> _updateUserName() async {
    final String newName = _nameController.text;
    await _userBox.saveUserName(newName);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(tr('account.updated_username',args:[newName])),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('account.user_name')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(tr('settings.enter_username')),
            TextField(
              controller: _nameController,
            ),
            const SizedBox(height: 16,),
            Row(mainAxisAlignment: MainAxisAlignment.end,
              children: [
              FilledButton(
              onPressed: _updateUserName, // Use _updateUserName instead of _saveUserName
              child: Text(tr('settings.update_username')), // Change the button label
            ),
            ],)
          ],
        ),
      ),
    );
  }
}
