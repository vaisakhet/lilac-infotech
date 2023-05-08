import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:video_downloader/Screens/home_Screen.dart';
import 'package:video_downloader/Theme/theme.dart';
import 'package:video_downloader/Widgets/settings_screen.dart';
import 'Screens/otp_screen.dart';
import 'Screens/phone_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Plugin must be initialized before using
  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    currentTheme.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);

    return MaterialApp(
      scaffoldMessengerKey: _scaffoldKey,
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      themeMode: currentTheme.currentTheme,
      initialRoute: 'PhoneScreen',
      routes: {
        'PhoneScreen': (context) => const PhoneScreen(),
        'OtpScreen': (context) => const OtpScreen(),
        'HomeScreen': (context) => HomeScreen(),
        'SettingScreen': (context) => const SettingsScreen(),
      },
    );
  }
}
