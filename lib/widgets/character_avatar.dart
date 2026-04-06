import 'package:flutter/material.dart';
import '../models/user_model.dart';

/// A gamified avatar widget that shows the user's level and XP progress.
class CharacterAvatar extends StatelessWidget {
  final UserModel user;

  const CharacterAvatar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Outer Ring showing XP progress
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                value: user.percentToNextLevel,
                strokeWidth: 8,
                backgroundColor: Colors.white10,
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            ),
            // The Hero's Portrait
            CircleAvatar(
              radius: 42,
              backgroundColor: Theme.of(context).cardColor,
              child: Icon(
                _getHeroIcon(user.currentLevel),
                size: 40,
                color: primaryColor,
              ),
            ),
            // Level Badge
            Positioned(
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'LVL ${user.currentLevel}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'XP: ${user.points} / ${user.xpForNextLevel}',
          style: const TextStyle(color: Colors.white38, fontSize: 12),
        ),
      ],
    );
  }

  /// Returns a progressively "cooler" icon as the user levels up.
  IconData _getHeroIcon(int level) {
    if (level < 3) return Icons.person_outline;
    if (level < 6) return Icons.shield_outlined;
    if (level < 10) return Icons.auto_fix_normal_outlined;
    if (level < 15) return Icons.military_tech_outlined;
    return Icons.workspace_premium_outlined;
  }
}
