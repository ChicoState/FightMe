import 'package:fightme_webapp/Cosmetics/profile_pictures.dart';
import 'package:fightme_webapp/Models/httpservice.dart';
import 'package:fightme_webapp/Providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'globals.dart' as globals;

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
    List<Widget> modes = <Widget>[const Text("Light"), const Text("Dark")];
    final List<bool> selectedModes = [
      settingsProvider.themeMode == ThemeMode.light,
      settingsProvider.themeMode == ThemeMode.dark
    ];
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
              Tab(text: "Profile"),
              Tab(text: "Theme"),
              Tab(text: "Payment"),
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
            firstPage(),
            secondPage(selectedModes, modes, settingsProvider),
            thirdPage(context),
          ],
        ),
      ),
    ));
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
                        const Text("Profile Information",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        Text("Your Email: ${globals.curUser.email}"),
                        Text("Your Password: ${globals.curUser.password}"),
                        Text("Your Username: ${globals.curUser.name}"),
                        const SizedBox(height: 20),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Avatar",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
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
                                    backgroundColor:
                                        Colors.black.withOpacity(0.7),
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Notifications", style: TextStyle(fontWeight:FontWeight.bold, fontSize: 20)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Friend Requests", style: TextStyle(fontWeight:FontWeight.bold, fontSize: 20)),
                      ],
                    ),
                  ],
                )
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
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              const AlertDialog(
                                content: SizedBox(
                                    width: 200,
                                    height: 200,
                                    child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text("Thank You For Thinking About Giving Us Money!"),
                                          ],
                                        )),
                              ));
                    },
                    child: const Text("Something3")),
              ],
            ),
          );
  }

  Padding secondPage(List<bool> selectedModes, List<Widget> modes, SettingsProvider settingsProvider) {
    return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ToggleButtons(
                  isSelected: selectedModes,
                  children: modes,
                  onPressed: (int index) {
                    ThemeMode newMode =
                        index == 0 ? ThemeMode.light : ThemeMode.dark;
                    settingsProvider.updateTheme(newMode);
                  },
                ),
              ],
            ),
          );
  }
// this is for the profile picture choosing
  Future<dynamic> dialogMethod(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose Your Avatar'),
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
                     HttpService().updateUserProfilePicture(globals.uid, index);
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
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
