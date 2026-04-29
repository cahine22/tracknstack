import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/savings_goal_model.dart';
import '../providers/transaction_provider.dart';
import '../providers/user_provider.dart';
import 'quest_button.dart';
import 'quest_text_field.dart';

class GoalCompletionDialog extends StatefulWidget {
  final String uid;
  final SavingsGoalModel goal;
  final VoidCallback onGoalSet;

  const GoalCompletionDialog({
    super.key,
    required this.uid,
    required this.goal,
    required this.onGoalSet,
  });

  @override
  State<GoalCompletionDialog> createState() => _GoalCompletionDialogState();
}

class _GoalCompletionDialogState extends State<GoalCompletionDialog> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

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
            Text(
              'You have mastered the quest "${widget.goal.name}" and earned 500 bonus XP! Your legend grows.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
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
                  final totalSavings = ref.read(totalSavingsProvider);
                  final navigator = Navigator.of(context);
                  
                  await ref.read(userServiceProvider).startNewSavingsGoal(
                    widget.uid,
                    name,
                    amount,
                    totalSavings,
                    completedGoalId: widget.goal.id,
                  );
                  
                  if (mounted) {
                    navigator.pop();
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

class AddNewGoalDialog extends StatefulWidget {
  final String uid;

  const AddNewGoalDialog({super.key, required this.uid});

  @override
  State<AddNewGoalDialog> createState() => _AddNewGoalDialogState();
}

class _AddNewGoalDialogState extends State<AddNewGoalDialog> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF3E2723),
      title: const Text('New Savings Quest', style: TextStyle(color: Colors.white)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          QuestTextField(
            controller: _nameController,
            labelText: 'Goal Name',
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
      actions: [
        Consumer(
          builder: (context, ref, child) {
            return QuestButton(
              label: 'Start Quest',
              isLoading: _isLoading,
              onPressed: () async {
                final name = _nameController.text.trim();
                final amount = double.tryParse(_amountController.text.trim());
                
                if (name.isEmpty || amount == null || amount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter valid details.')),
                  );
                  return;
                }

                setState(() => _isLoading = true);
                try {
                  final goal = SavingsGoalModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: name,
                    target: amount,
                    baseAmount: ref.read(totalSavingsProvider),
                  );
                  final navigator = Navigator.of(context);
                  await ref.read(userServiceProvider).addSavingsGoal(widget.uid, goal);
                  if (mounted) navigator.pop();
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add goal: $e')),
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
