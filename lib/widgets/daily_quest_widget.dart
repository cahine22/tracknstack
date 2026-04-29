import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';

class DailyQuestWidget extends ConsumerWidget {
  final UserModel user;

  const DailyQuestWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final isResetNeeded = user.lastQuestResetDate != today;
    final completedQuests = isResetNeeded ? <String>[] : user.completedQuests;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DAILY BOUNTIES',
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
          isCompleted: completedQuests.contains('daily_log'),
          onComplete: () {
            ref.read(userServiceProvider).completeQuest(user.uid, 'daily_log', 20);
          },
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
  final VoidCallback onComplete;

  const _QuestItem({
    required this.id,
    required this.title,
    required this.reward,
    required this.isCompleted,
    required this.onComplete,
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
          Icon(
            isCompleted ? Icons.check_circle : Icons.RadioButtonUnchecked,
            color: isCompleted ? theme.primaryColor : Colors.white38,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    color: isCompleted ? Colors.white38 : Colors.white,
                  ),
                ),
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
          ),
          if (!isCompleted)
            ElevatedButton(
              onPressed: onComplete,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                minimumSize: const Size(0, 36),
              ),
              child: const Text('CLAIM'),
            ),
        ],
      ),
    );
  }
}
