import 'package:flutter/material.dart';
import 'package:video_downloader/Theme/theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        width: double.infinity,
        height: 60,
        margin: const EdgeInsets.all(10),
        child: PhysicalModel(
          color: Colors.white,
          elevation: 8,
          shadowColor: Colors.blue,
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
              height: 60,
              width: 60,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Light / Dark',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    IconButton(
                        onPressed: () {
                          currentTheme.toggleTheme();
                        },
                        icon: CustomTheme.isDarkTheme
                            ? const Icon(Icons.nights_stay)
                            : const Icon(Icons.wb_sunny))
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
