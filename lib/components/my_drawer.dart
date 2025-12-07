import 'package:flutter/material.dart';
import 'package:trackit/pages/analysis.dart';
import 'package:trackit/pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Drawer(
      backgroundColor: cs.surface,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 50,),
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage('assets/images/logo.png'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      '   Daily Do',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: cs.inversePrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 50),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: [
                  _DrawerCardTile(
                    icon: Icons.home_outlined,
                    label: 'Home',
                    onTap: () => Navigator.pop(context),
                    cs: cs,
                  ),
                  _DrawerCardTile(
                    icon: Icons.analytics,
                    label: 'Analysis',
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AnalysisPage()),
                        ),
                    cs: cs,
                  ),
                  _DrawerCardTile(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SettingsPage()),
                        ),
                    cs: cs,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerCardTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final ColorScheme cs;

  const _DrawerCardTile({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: cs.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: cs.inversePrimary),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: cs.inversePrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: cs.inversePrimary),
        onTap: onTap,
      ),
    );
  }
}
