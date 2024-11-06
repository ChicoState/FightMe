import 'package:fightme_webapp/Models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fightme_webapp/globals.dart' as globals;

Future<void> clearUserData() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('userId');
  globals.uid = 0;
  globals.curUser = User("");
  globals.loggedIn = false;
}