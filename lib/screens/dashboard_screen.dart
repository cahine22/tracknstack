import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/savings_progress_bar.dart';
import '../widgets/quick_log_widget.dart';
import '../widgets/summary_section.dart';
import '../widgets/character_avatar.dart';
import '../widgets/quest_text_field.dart';
import '../widgets/quest_button.dart';

import 'setup_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _isShowingGoalDialog = false;

  void _checkGoalCompletion(double totalSavings) {
    final userData = ref.read(userDataProvider).value;
    if (userData == null || userData.savingsGoalTarget == 0) return;

    final currentGoalSavings = totalSavings - userData.savingsGoalBase;
    if (currentGoalSavings >= userData.savingsGoalTarget && !_isShowingGoalDialog) {
      _showGoalReachedDialog(userData.uid, totalSavings);
    }
  }

  void _showGoalReachedDialog(String uid, double totalSavings) {
    setState(() => _isShowingGoalDialog = true);
    
    // Award bonus XP for reaching the goal (Task 17)
    ref.read(userServiceProvider).awardBonusXP(uid, 500);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _GoalCompletionDialog(
        uid: uid,
        currentTotalSavings: totalSavings,
        onGoalSet: () {
          setState(() => _isShowingGoalDialog = false);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch total savings to trigger goal completion logic
    ref.listen(totalSavingsProvider, (previous, next) {
      _checkGoalCompletion(next);
    });

    // Watch the real-time user data from Firestore.
    final userDataAsync = ref.watch(userDataProvider);

    return userDataAsync.when(
      data: (user) {
        if (user == null) {
          return const SetupScreen();
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('TRACK N STACK'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  ref.read(authServiceProvider).signOut();
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Character Profile Section
                Row(
                  children: [
                    CharacterAvatar(user: user),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.displayName,
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Financial Hero',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Savings Progress Bar
                const SavingsProgressBar(),
                const SizedBox(height: 32),

                // Quick Log Widget
                const QuickLogWidget(),
                const SizedBox(height: 32),

                // Summary Cards
                const SummarySection(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text('Error loading profile: $err'),
          ),
        ),
      ),
    );
  }
}

class _GoalCompletionDialog extends StatefulWidget {
  final String uid;
  final double currentTotalSavings;
  final VoidCallback onGoalSet;

  const _GoalCompletionDialog({
    required this.uid,
    required this.currentTotalSavings,
    required this.onGoalSet,
  });

  @override
  State<_GoalCompletionDialog> createState() => _GoalCompletionDialogState();
}

class _GoalCompletionDialogState extends State<_GoalCompletionDialog> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return AlertDialog(
      backgroundColor: const Color(0xFF3E2723), // Dark brown theme
      title: Column(
        children: [
          const Icon(Icons.workspace_premium, size: 64, color: Colors.amber),
          const SizedBox(height: 16),
          Text(
            'GOAL REACHED!',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'You have mastered this quest and earned 500 bonus XP! Your legend grows.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 24),
            const Text(
              'What is your next great challenge?',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 16),
            QuestTextField(
              controller: _nameController,
              labelText: 'New Goal Name',
              prefixIcon: Icons.flag_outlined,
            ),
            const SizedBox(height: 16),
            QuestTextField(
              controller: _amountController,
              labelText: 'Target Amount (\$)',
              prefixIcon: Icons.savings_outlined,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        Consumer(
          builder: (context, ref, child) {
            return QuestButton(
              label: 'Set New Goal',
              isLoading: _isLoading,
              onPressed: () async {
                final name = _nameController.text.trim();
                final amount = double.tryParse(_amountController.text.trim());
                
                if (name.isEmpty || amount == null || amount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please define your next quest.')),
                  );
                  return;
                }

                setState(() => _isLoading = true);
                try {
                  await ref.read(userServiceProvider).startNewSavingsGoal(
                    widget.uid,
                    name,
                    amount,
                    widget.currentTotalSavings,
                  );
                  if (mounted) {
                    Navigator.of(context).pop();
                    widget.onGoalSet();
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to set new goal: $e')),
                    );
                  }
                } finally {
                  if (mounted) setState(() => _isLoading = false);
                }
              },
            );
          },
        ),
      ],
    );
  }
}
