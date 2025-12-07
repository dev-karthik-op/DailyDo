import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackit/Introduction%20Screen/onboarding_screen.dart';
import 'package:trackit/database/habit_database.dart';
import 'package:trackit/pages/home_page.dart';
import 'package:trackit/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize database
  await HabitDatabase.initialize();
  await HabitDatabase().saveFirstLaunchDate();

  runApp(
    MultiProvider(providers: [
        // habit provider
        ChangeNotifierProvider(create: (context) => HabitDatabase()),
        // theme provider
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _checkOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('seenOnboarding') ?? false;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Do',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: _checkOnboardingSeen(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // still loading
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.data!) {
            // already seen → go to Home
            return const HomePage();
          } else {
            // first time → show onboarding
            return const OnboardingScreen();
          }
        },
      ),
      theme: Provider.of<ThemeProvider>(context).themeData, //Change the Theme of App
    );
  }
}
