import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/transaction_provider.dart';
import '../providers/user_provider.dart';

class SavingsProgressBar extends ConsumerWidget {
  const SavingsProgressBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider).value;
    final savingsByGoal = ref.watch(savingsByGoalProvider);
    final primaryColor = Theme.of(context).primaryColor;

    if (userData == null || userData.savingsGoals.isEmpty) {
      return const SizedBox.shrink();
    }

    final activeGoals = userData.savingsGoals.where((g) => !g.isCompleted).toList();

    if (activeGoals.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: activeGoals.map((goal) {
        final currentGoalSavings = savingsByGoal[goal.id] ?? 0.0;
        final progress = (currentGoalSavings / goal.target).clamp(0.0, 1.0);
        final percentage = (progress * 100).toStringAsFixed(1);

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      goal.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      '$percentage%',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 12,
                    backgroundColor: primaryColor.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '\$${currentGoalSavings.toStringAsFixed(2)} / \$${goal.target.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
