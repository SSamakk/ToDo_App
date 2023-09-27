import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../firebaseUtils.dart';
import '../model/task.dart';

class AppConfigProvider extends ChangeNotifier {
  // data
  String appLanguage = 'en';
  ThemeMode appTheme = ThemeMode.light;
  List<Task> tasksList = [];

  // methods
  void changeLanguage(String newLanguage) {
    if (appLanguage == newLanguage) {
      return;
    }
    appLanguage = newLanguage;
    notifyListeners();
  }

  void changeTheme(ThemeMode newTheme) {
    if (appTheme == newTheme) {
      return;
    }
    appTheme = newTheme;
    notifyListeners();
  }

  bool isDark() {
    if (appTheme == ThemeMode.dark) {
      return true;
    } else {
      return false;
    }
  }

  bool isEnglish() {
    if (appLanguage == 'en') {
      return true;
    } else {
      return false;
    }
  }

  void getAllTasks() async {
    QuerySnapshot<Task> querySnapshot =
    await FireBaseUtils.getTasksCollection().get();

    tasksList = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();

    notifyListeners();
  }
}