
// Setting Page

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Introduction Screen/onboarding_screen.dart';
import '../theme/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(color: colorScheme.inversePrimary),
        ),
        backgroundColor: colorScheme.surface,
        iconTheme: IconThemeData(color: colorScheme.inversePrimary),
        elevation: 0,
      ),
      backgroundColor: colorScheme.surface,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(
                Icons.brightness_6,
                color: colorScheme.inversePrimary,
              ),
              title: Text(
                "Dark Mode",
                style: TextStyle(color: colorScheme.inversePrimary),
              ),
              trailing: CupertinoSwitch(
                value: isDarkMode,
                onChanged:
                    (value) =>
                        Provider.of<ThemeProvider>(
                          context,
                          listen: false,
                        ).toggleTheme(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text("Log Out", style: TextStyle(color: Colors.red)),
              onTap: () async {
                // 1. Clear the flag
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('seenOnboarding', false);

                // 2. Push onboarding and remove everything else
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                  (_) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
