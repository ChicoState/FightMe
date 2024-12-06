import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fightme_webapp/Cosmetics/profile_pictures.dart'; // Import the profile pictures list
import 'package:fightme_webapp/Cosmetics/themes.dart';

class SettingsProvider with ChangeNotifier {
  static const _profilePictureIndexKey = 'profilePictureIndex';
  static const _themeIndexKey = 'themeIndex';

  int _profilePictureIndex = 0;
  int _themeIndex = 0;

  int get themeIndex => _themeIndex;
  int get profilePictureIndex => _profilePictureIndex;

  // Get the current profile picture path
  String get profilePicture => profilePictures[_profilePictureIndex];
  // Get the current theme
  ColorScheme get theme => themes[_themeIndex];

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _themeIndex = prefs.getInt(_themeIndexKey) ?? 0;
    _profilePictureIndex = prefs.getInt(_profilePictureIndexKey) ?? 0;
    notifyListeners();
  }

  Future<void> updateTheme(int themeIndex) async {
    _themeIndex = themeIndex;
     final prefs = await SharedPreferences.getInstance();
     await prefs.setInt(_themeIndexKey, themeIndex);
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
