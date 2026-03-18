import 'package:flutter/material.dart';

/// A reusable branding widget for the "Financial Quest" screens.
/// 
/// This widget displays a large icon and the app's mystical 
/// title, ensuring brand consistency across the UI.
class QuestBranding extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const QuestBranding({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // Using colorScheme.primary is the most reliable way to get our Emerald Green.
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Column(
      children: [
        Center(
          child: Icon(
            icon,
            size: 80,
            color: primaryColor, // This will now be the exact button green
          ),
        ),
        const SizedBox(height: 24),
        Text(
          title,
          style: textTheme.displayLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(color: Colors.white70, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
