import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/quest_branding.dart';
import '../widgets/quest_text_field.dart';
import '../widgets/quest_button.dart';

class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  final _nameController = TextEditingController();
  final _budgetController = TextEditingController();
  final _goalNameController = TextEditingController();
  final _goalAmountController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authStateProvider).value;
    if (user?.displayName != null) {
      _nameController.text = user!.displayName!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _budgetController.dispose();
    _goalNameController.dispose();
    _goalAmountController.dispose();
    super.dispose();
  }

  Future<void> _completeSetup() async {
    if (_nameController.text.trim().isEmpty || 
        _budgetController.text.trim().isEmpty || 
        _goalNameController.text.trim().isEmpty || 
        _goalAmountController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all scrolls to begin your quest.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final authUser = ref.read(authStateProvider).value;
      if (authUser != null) {
        final spendingBudget = double.parse(_budgetController.text.trim());
        // Simple distribution for SPENDING only (Prompt 10)
        // Savings is now handled separately by the Savings Goal.
        final newUser = UserModel(
          uid: authUser.uid,
          email: authUser.email ?? '',
          displayName: _nameController.text.trim(),
          monthlyBudget: spendingBudget,
          categoryBudgets: {
            'needs': spendingBudget * 0.6,
            'wants': spendingBudget * 0.4,
            'savings': 0.0, // Separated from the spending budget
            'others': 0.0,
          },
          savingsGoalTarget: double.parse(_goalAmountController.text.trim()),
          savingsGoalName: _goalNameController.text.trim(),
        );
        
        await ref.read(userServiceProvider).saveUser(newUser);
        // The [userDataProvider] will now emit this user, 
        // and [DashboardScreen] will show the normal dashboard.
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to initialize your quest: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const QuestBranding(
                icon: Icons.auto_fix_high,
                title: 'Initial Setup',
                subtitle: 'Prepare your hero for the financial quest ahead.',
              ),
              const SizedBox(height: 32),
              QuestTextField(
                controller: _nameController,
                labelText: 'Hero Name',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              QuestTextField(
                controller: _budgetController,
                labelText: 'Total Monthly Budget (\$)',
                prefixIcon: Icons.account_balance_wallet_outlined,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              QuestTextField(
                controller: _goalNameController,
                labelText: 'Savings Goal Name',
                prefixIcon: Icons.flag_outlined,
              ),
              const SizedBox(height: 16),
              QuestTextField(
                controller: _goalAmountController,
                labelText: 'Savings Goal Amount (\$)',
                prefixIcon: Icons.savings_outlined,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 32),
              QuestButton(
                label: 'Enter the Realm',
                onPressed: _completeSetup,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
