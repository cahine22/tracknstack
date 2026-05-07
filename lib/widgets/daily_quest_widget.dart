import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';

class DailyQuestWidget extends ConsumerWidget {
  final UserModel user;

  const DailyQuestWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final isResetNeeded = user.lastQuestResetDate != today;
    final completedQuests = isResetNeeded ? <String>[] : user.completedQuests;
    final isLogCompleted = completedQuests.contains('daily_log');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DAILY CHALLENGE',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            letterSpacing: 2.0,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 12),
        _QuestItem(
          id: 'daily_log',
          title: "Log today's spending",
          reward: '+20 XP',
          isCompleted: isLogCompleted,
          description: isLogCompleted 
            ? "Bounty collected! Check back tomorrow." 
            : "Complete a 'Quick Log' to earn this reward.",
        ),
      ],
    );
  }
}

class _QuestItem extends StatelessWidget {
  final String id;
  final String title;
  final String reward;
  final bool isCompleted;
  final String description;

  const _QuestItem({
    required this.id,
    required this.title,
    required this.reward,
    required this.isCompleted,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted ? theme.primaryColor : Colors.white10,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isCompleted ? theme.primaryColor.withValues(alpha: 0.1) : Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCompleted ? Icons.check_circle : Icons.pending_actions_rounded,
              color: isCompleted ? theme.primaryColor : Colors.white38,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: isCompleted ? TextDecoration.lineThrough : null,
                        color: isCompleted ? Colors.white38 : Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      reward,
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
