import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

import '../shared_prefs/shared_prefs.dart';
import 'session_storage_repositories.dart';

class RouterUtils with ChangeNotifier {
  final SharedPrefs sharedPrefs;
  final SessionStorageRepositories storage;
  BehaviorSubject<bool> isLoggedInController =
      BehaviorSubject<bool>(sync: true);
  RouterUtils({
    required this.sharedPrefs,
    required this.storage,
  }) {
    isLoggedInController.add(storage.isLoggedIn);
    sharedPrefs.welcomeScreenData.addListener(() {
      notifyListeners();
    });
    storage.addListener(() async {
      isLoggedInController.stream.listen((bool value) async {
        if (value != await isLoggedInController.stream.elementAt(1)) {
          notifyListeners();
        }
      });
    });
  }
}
