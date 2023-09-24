// ignore_for_file: always_specify_types, strict_raw_type

import 'package:hive/hive.dart';

class UserBox {
  static const String _boxName = 'userBox';
  
  Future<void> saveUserName(String name) async {
    final box = await Hive.openBox(_boxName);
    await box.put('userName', name);
  }

  Future getUserName() async {

    final box = await Hive.openBox(_boxName);
    return box.get('userName');
  }
}
