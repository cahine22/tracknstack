import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';
import '../providers/user_provider.dart';
import 'spending_budget_card.dart';
import 'summary_card.dart';
import '../screens/transaction_history_screen.dart';

/// A section that displays financial summaries using modular cards.
class SummarySection extends ConsumerWidget {
  const SummarySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider).value;
    final categoryTotals = ref.watch(categoryTotalsProvider);

    if (userData == null) return const SizedBox.shrink();

    final spendingCategories = [
      TransactionCategory.needs,
      TransactionCategory.wants,
      TransactionCategory.others,
    ];
    final savingsCategory = TransactionCategory.savings;

    final totalSpent = spendingCategories.fold(0.0, (sum, cat) => sum + (categoryTotals[cat] ?? 0.0));
    final totalBudget = spendingCategories.fold(0.0, (sum, cat) => sum + (userData.categoryBudgets[cat.name] ?? 0.0));

    void navigateToHistory(TransactionCategory? category) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TransactionHistoryScreen(filterCategory: category),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SpendingBudgetCard(spent: totalSpent, budget: totalBudget),
        const SizedBox(height: 24),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Quest Progress Summary',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () => navigateToHistory(null),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.1,
          children: spendingCategories.map((category) {
            return SummaryCard(
              category: category,
              spent: categoryTotals[category] ?? 0.0,
              budget: userData.categoryBudgets[category.name] ?? 0.0,
              isSubGoal: true,
              onTap: () => navigateToHistory(category),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        
        SummaryCard(
          category: savingsCategory,
          spent: categoryTotals[savingsCategory] ?? 0.0,
          budget: userData.categoryBudgets[savingsCategory.name] ?? 0.0,
          isSubGoal: false,
          isFullWidth: true,
          onTap: () => navigateToHistory(savingsCategory),
        ),
      ],
    );
  }
}
