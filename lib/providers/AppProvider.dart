import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../firebaseUtils.dart';
import '../model/task.dart';

class AppConfigProvider extends ChangeNotifier {
  // data
  String appLanguage = 'en';
  ThemeMode appTheme = ThemeMode.light;
  bool dark;
  bool english;

  // list
  List<Task> tasksList = [];
  DateTime selectedDate = DateTime.now();

  AppConfigProvider({required this.dark, required this.english}){
    appTheme = dark ? ThemeMode.dark : ThemeMode.light;
    appLanguage = english ? 'en' : 'ar';
  }

  // methods
  void changeLanguage(String newLanguage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (appLanguage == newLanguage) {
      return;
    }
    appLanguage = newLanguage;

    prefs.setBool('english', appLanguage == 'en' ? true : false);

    notifyListeners();
  }

  void changeTheme(ThemeMode newTheme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (appTheme == newTheme) {
      return;
    }
    appTheme = newTheme;

    prefs.setBool('darkMode', appTheme == ThemeMode.dark ? true : false);

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

  void getAllTasks(String uId) async {

    QuerySnapshot<Task> querySnapshot =
        await FireBaseUtils.getTasksCollection(uId).orderBy(
            'date', descending: false).get();

    tasksList = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();

    // filter (selected date)
    tasksList = tasksList.where((task) {
      if(task.date?.day == selectedDate.day
      && task.date?.month == selectedDate.month
      && task.date?.year == selectedDate.year){
        return true;
      }
      return false;
    }).toList();

    // // sort list
    // tasksList.sort(
    //     (Task task1, Task task2){
    //       return task1.date!.compareTo(task2.date!);
    //     }
    // );

    notifyListeners();
  }

  void changeDate(DateTime newDate, String uId){
    selectedDate = newDate;
    getAllTasks(uId);
  }

}