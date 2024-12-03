import 'package:fightme_webapp/Cosmetics/profile_pictures.dart';
import 'package:fightme_webapp/Models/httpservice.dart';
import 'package:fightme_webapp/Providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'globals.dart' as globals;
import 'package:fightme_webapp/Cosmetics/themes.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);

    // Use the available theme names and the corresponding list of themes
    List<Widget> themeOptions = List.generate(
      themes.length,
      (index) => Text(
        themeNames[index],
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );

    // Select the current theme based on the settings
    final List<bool> selectedThemes = List.generate(
      themes.length,
      (index) => settingsProvider.themeIndex == index,
    );

    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              indicatorColor: Colors.black,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black,
              indicatorWeight: 4,
              tabs: [
                Tab(text: "Profile", icon: Icon(Icons.person)),
                Tab(text: "Theme", icon: Icon(Icons.color_lens)),
                Tab(text: "Payment", icon: Icon(Icons.monetization_on)),
              ],
            ),
            title: const Text("Settings"),
            backgroundColor: Theme.of(context).colorScheme.primary,
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: TabBarView(
            children: [
              // First Page: Profile
              Container(
                color: Theme.of(context)
                    .colorScheme
                    .surface,
                child: firstPage(),
              ),
              // Second Page: Theme settings
              Container(
                color: Theme.of(context)
                    .colorScheme
                    .surface,
                child:
                    secondPage(selectedThemes, themeOptions, settingsProvider),
              ),
              // Third Page: Payment
              Container(
                color: Theme.of(context)
                    .colorScheme
                    .surface,
                child: thirdPage(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding firstPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Profile Information",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Theme.of(context).textTheme.bodyLarge!.color),
                  ),
                  Text("Your Email: ${globals.curUser.email}",
                      style: Theme.of(context).textTheme.bodyLarge),
                  Text("Your Password: ${globals.curUser.password}",
                      style: Theme.of(context).textTheme.bodyLarge),
                  Text("Your Username: ${globals.curUser.name}",
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 20),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Avatar",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Theme.of(context).textTheme.bodyLarge!.color),
                  ),
                  Consumer<SettingsProvider>(
                    builder: (context, settingsProvider, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipOval(
                            child: Image.asset(
                              profilePictures[globals.curUser.pfp],
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: CircleAvatar(
                              backgroundColor: Colors.black.withOpacity(0.7),
                              radius: 20,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                                iconSize: 20,
                                onPressed: () {
                                  dialogMethod(context);
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  )
                ],
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Notifications",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Theme.of(context).textTheme.bodyLarge!.color)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Friend Requests",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Theme.of(context).textTheme.bodyLarge!.color)),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Padding secondPage(List<bool> selectedThemes, List<Widget> themeOptions,
      SettingsProvider settingsProvider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ToggleButtons(
            mouseCursor: SystemMouseCursors.click,
            borderColor: Theme.of(context).colorScheme.primary,
            selectedBorderColor: Theme.of(context).colorScheme.secondary,
            isSelected: selectedThemes,
            children: themeOptions,
            onPressed: (int index) {
              settingsProvider.updateTheme(index);
            },
          ),
        ],
      ),
    );
  }

  Padding thirdPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                Theme.of(context).colorScheme.primary,
              ),
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        content: SizedBox(
                          width: 200,
                          height: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Thank You For Thinking About Giving Us Money!",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ));
            },
            child: Text("Something3",
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  // This is for the profile picture choosing
  Future<dynamic> dialogMethod(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Consumer<SettingsProvider>(
            builder: (context, settingsProvider, child) {
            ColorScheme currentTheme = settingsProvider.theme;
          return AlertDialog(
            backgroundColor: currentTheme.surface,
            title: Text(
              'Choose Your Avatar',
              style: TextStyle(fontSize: 20, color: currentTheme.primary),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Number of avatars per row
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: profilePictures.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Provider.of<SettingsProvider>(context, listen: false)
                          .updateProfilePicture(index);
                      HttpService()
                          .updateUserProfilePicture(globals.uid, index);
                      globals.curUser.pfp =
                          index; // Update global user profile index
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: ClipOval(
                      child: Image.asset(
                        profilePictures[index],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle( color: currentTheme.primary, fontSize: 20),
                ),
              ),
            ],
          );
        });
      },
    );
  }
}
