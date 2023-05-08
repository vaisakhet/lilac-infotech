import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ), //BoxDecoration
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              accountName: const Text(
                "Abhishek Mishra",
                style: TextStyle(fontSize: 18),
              ),
              accountEmail: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text("abhishekm977@gmail.com"),
                  Text('DOB : 21-03-1994')
                ],
              ),
              currentAccountPictureSize: const Size.square(40),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Color.fromARGB(255, 165, 255, 137),
                backgroundImage: NetworkImage(
                    "https://www.shutterstock.com/image-photo/head-shot-portrait-close-smiling-260nw-1714666150.jpg"),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pushNamed(context, 'SettingScreen');
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('LogOut'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, 'PhoneScreen', (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
