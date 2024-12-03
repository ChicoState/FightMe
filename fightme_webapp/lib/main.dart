import 'package:fightme_webapp/fight_game_page.dart';
import 'package:fightme_webapp/Providers/settings_provider.dart'; // Import the SettingsProvider
import 'package:fightme_webapp/Providers/stats_provider.dart';
import 'package:fightme_webapp/training_area_page.dart';
import 'home.dart';
import 'Models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'globals.dart' as globals;

User curUser = User("placeholder");

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsProvider = SettingsProvider();
  await settingsProvider.loadSettings(); // Load user settings before the app starts
  final statsProvider = StatsProvider();
  // final friendsProvider = FriendsProvider();

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => settingsProvider),
      ChangeNotifierProvider(create: (_) => statsProvider),
      // ChangeNotifierProvider(create: (_) => friendsProvider),
    ],
    child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return MaterialApp(
      title: 'Fight Me',
      theme: ThemeData.from(colorScheme: settingsProvider.theme),
      home: globals.loggedIn ? TrainingAreaPage(curUser: globals.curUser) : Home(),
    );
  }
}
