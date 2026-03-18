import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction_model.dart';
import '../providers/auth_provider.dart';
import '../providers/transaction_provider.dart';
import 'quest_button.dart';
import 'quest_text_field.dart';

class QuickLogWidget extends ConsumerStatefulWidget {
  const QuickLogWidget({super.key});

  @override
  ConsumerState<QuickLogWidget> createState() => _QuickLogWidgetState();
}

class _QuickLogWidgetState extends ConsumerState<QuickLogWidget> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  TransactionCategory _selectedCategory = TransactionCategory.needs;
  bool _isSaving = false;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveTransaction() async {
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount.')),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final user = ref.read(authStateProvider).value;
      if (user != null) {
        final transaction = TransactionModel(
          userId: user.uid,
          amount: amount,
          category: _selectedCategory,
          date: DateTime.now(),
          note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
        );
        await ref.read(transactionServiceProvider).addTransaction(transaction);
        
        _amountController.clear();
        _noteController.clear();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Transaction logged! +5 XP (XP logic coming soon)')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to log transaction: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Quick Log',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            QuestTextField(
              controller: _amountController,
              labelText: String.fromCharCode( 0x0024) + ' Amount',
              prefixIcon: Icons.attach_money,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<TransactionCategory>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category_outlined),
              ),
              items: TransactionCategory.values.map((cat) {
                return DropdownMenuItem(
                  value: cat,
                  child: Text(cat.displayName),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedCategory = val);
              },
            ),
            const SizedBox(height: 20),
            QuestButton(
              label: 'Log Transaction',
              onPressed: _saveTransaction,
              isLoading: _isSaving,
            ),
          ],
        ),
      ),
    );
  }
}
