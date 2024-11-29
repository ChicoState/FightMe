import 'package:fightme_webapp/Cosmetics/profile_pictures.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(length: 3,
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
          backgroundColor: Theme
                .of(context)
                .colorScheme
                .primary,
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
             Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Profile Information", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                         SizedBox(height: 8), // Add spacing above the divider
                         Divider(
                          color: Colors.black, // Set divider color
                          thickness: 1, // Set divider thickness
                          indent: 20, // Optional: Add padding on the left
                          endIndent: 20, // Optional: Add padding on the right
                        ),
                         SizedBox(height: 8), // Add spacing below the divider
                        Text("Your Email"),
                        Text("Your Password"),
                        Text("Your Username"), 
                        SizedBox(height: 20),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Avatar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        Stack(
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
                              onPressed: (){},
                            ),
                          ),
                        ),
                      ],)
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        
                      },
                       child: const Text("Something2")
                       ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed:() {
                      },
                       child: const Text("Something3")
                       ),
                  ],
                ),
              ),
          ],
        ),
      ),
      )
    );
  }
}