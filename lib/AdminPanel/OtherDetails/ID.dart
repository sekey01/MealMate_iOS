import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class AdminId extends ChangeNotifier {
  String adminID = '0';

  get id => adminID;

  Future<void> changeId(String newValue) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filepath = '${directory.path}/AdminId.txt';
      final file = File(filepath);

      if (!await file.exists()) {
        await file.create(recursive: true);
      }

      await file.writeAsString(newValue);

      adminID = newValue;

      notifyListeners();
    } catch (e) {
      print("Error changing ID: $e");
    }
  }

  Future<void> loadId() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filepath = '${directory.path}/AdminId.txt';
      final file = File(filepath);

      if (await file.exists()) {
        String contents = await file.readAsString();
        adminID = contents;
      } else {
        adminID = '0';
      }

      notifyListeners();
    } catch (e) {
      print("Error loading ID: $e");
    }
  }
}
