import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/savings_progress_bar.dart';
import '../widgets/quick_log_widget.dart';
import '../widgets/summary_section.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/savings_goal_dialogs.dart';
import '../widgets/daily_quest_widget.dart';
import '../models/savings_goal_model.dart';

import 'setup_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _isShowingGoalDialog = false;

  void _checkGoalCompletion(Map<String, double> savingsByGoal) {
    final userData = ref.read(userDataProvider).value;
    if (userData == null || userData.savingsGoals.isEmpty) return;

    for (final goal in userData.savingsGoals) {
      if (goal.isCompleted) continue;
      
      final currentGoalSavings = savingsByGoal[goal.id] ?? 0.0;
      if (currentGoalSavings >= goal.target && !_isShowingGoalDialog) {
        _showGoalReachedDialog(userData.uid, goal);
      }
    }
  }

  void _showGoalReachedDialog(String uid, SavingsGoalModel goal) {
    setState(() => _isShowingGoalDialog = true);
    
    // Award bonus XP for reaching the goal (Task 17)
    ref.read(userServiceProvider).awardBonusXP(uid, 500);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => GoalCompletionDialog(
        uid: uid,
        goal: goal,
        onGoalSet: () {
          setState(() => _isShowingGoalDialog = false);
        },
      ),
    );
  }

  void _showAddNewGoalDialog(String uid) {
    showDialog(
      context: context,
      builder: (context) => AddNewGoalDialog(uid: uid),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch savingsByGoal to trigger goal completion logic
    ref.listen(savingsByGoalProvider, (previous, next) {
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
                DashboardHeader(user: user),
                const SizedBox(height: 32),

                // Savings Progress Bar Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ACTIVE QUESTS',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        letterSpacing: 2.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _showAddNewGoalDialog(user.uid),
                      icon: const Icon(Icons.add, size: 20),
                      label: const Text('New Quest'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Savings Progress Bar
                const SavingsProgressBar(),
                const SizedBox(height: 32),

                // Quick Log Widget
                const QuickLogWidget(),
                const SizedBox(height: 32),

                // Daily Quests
                DailyQuestWidget(user: user),
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
