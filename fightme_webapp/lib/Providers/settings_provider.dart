import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fightme_webapp/Cosmetics/profile_pictures.dart'; // Import the profile pictures list

class SettingsProvider with ChangeNotifier {
  static const _themeModeKey = 'themeMode';
  static const _profilePictureIndexKey = 'profilePictureIndex';

  ThemeMode _themeMode = ThemeMode.light;
  int _profilePictureIndex = 0;

  ThemeMode get themeMode => _themeMode;
  int get profilePictureIndex => _profilePictureIndex;

  // Get the current profile picture path
  String get profilePicture => profilePictures[_profilePictureIndex];

  // Load settings from SharedPreferences
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = (prefs.getString(_themeModeKey) ?? 'light') == 'dark'
        ? ThemeMode.dark
        : ThemeMode.light;
    _profilePictureIndex = prefs.getInt(_profilePictureIndexKey) ?? 0;
    notifyListeners();
  }

  // Update theme mode
  Future<void> updateTheme(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode == ThemeMode.dark ? 'dark' : 'light');
    notifyListeners();
  }

  // Update profile picture
  Future<void> updateProfilePicture(int newIndex) async {
    if (newIndex < 0 || newIndex >= profilePictures.length) {
      throw ArgumentError('Invalid profile picture index');
    }
    _profilePictureIndex = newIndex;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_profilePictureIndexKey, newIndex);
    notifyListeners();
  }
}
