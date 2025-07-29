import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateManager {
  static final AppStateManager instance = AppStateManager._internal();
  final ValueNotifier<AppState> appStateNotifier = ValueNotifier<AppState>(NotLoggedInState());
  static const String _key = 'app_state_key';

  AppStateManager._internal();

  // Save the current AppState to storage
  static Future<void> saveAppState(AppState state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, state.storageKey);
  }

  // Restore the AppState from storage
  Future<void> restoreAppState() async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(_key);
    final restoredState = key != null ? AppState.fromStorageKey(key) : NotLoggedInState();
    appStateNotifier.value = restoredState;
  }
}



sealed class AppState {
  const AppState();
  String get storageKey;

  static AppState fromStorageKey(String key) {
    switch (key) {
      case NotLoggedInState.storageKeyValue:
        return NotLoggedInState();
      case ProfileState.storageKeyValue:
        return ProfileState();
      case HomeState.storageKeyValue:
        return HomeState();
      default:
        return NotLoggedInState(); // fallback
    }
  }
}

class NotLoggedInState extends AppState {
  static const String storageKeyValue = 'NotLoggedIn';

  @override
  String get storageKey => storageKeyValue;
}

class ProfileState extends AppState {
  static const String storageKeyValue = 'Profile';

  @override
  String get storageKey => storageKeyValue;
}

class HomeState extends AppState {
  static const String storageKeyValue = 'Home';

  @override
  String get storageKey => storageKeyValue;
}


