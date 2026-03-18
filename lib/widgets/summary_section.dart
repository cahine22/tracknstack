import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';
import '../providers/user_provider.dart';

class SummarySection extends ConsumerWidget {
  const SummarySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider).value;
    final categoryTotals = ref.watch(categoryTotalsProvider);

    if (userData == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quest Progress Summary',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.1,
          children: TransactionCategory.values.map((category) {
            final spent = categoryTotals[category] ?? 0.0;
            final budget = userData.categoryBudgets[category.name] ?? 0.0;
            return _SummaryCard(
              category: category,
              spent: spent,
              budget: budget,
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final TransactionCategory category;
  final double spent;
  final double budget;

  const _SummaryCard({
    required this.category,
    required this.spent,
    required this.budget,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final isOverBudget = budget > 0 && spent > budget;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getCategoryIcon(category),
              color: primaryColor,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              category.displayName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '\$${spent.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: isOverBudget ? Colors.redAccent : Colors.white,
              ),
            ),
            if (budget > 0)
              Text(
                'Goal: \$${budget.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 12, color: Colors.white38),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.needs: return Icons.home_work_outlined;
      case TransactionCategory.wants: return Icons.shopping_bag_outlined;
      case TransactionCategory.savings: return Icons.savings_outlined;
      case TransactionCategory.others: return Icons.category_outlined;
    }
  }
}
