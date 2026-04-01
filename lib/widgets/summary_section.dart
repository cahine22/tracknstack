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

    // Separate categories into Spending and Savings
    final spendingCategories = [
      TransactionCategory.needs,
      TransactionCategory.wants,
      TransactionCategory.others,
    ];
    final savingsCategory = TransactionCategory.savings;

    // Total spending calculation (Excluding Savings per Prompt 10)
    final totalSpent = spendingCategories.fold(0.0, (sum, cat) => sum + (categoryTotals[cat] ?? 0.0));
    final totalBudget = spendingCategories.fold(0.0, (sum, cat) => sum + (userData.categoryBudgets[cat.name] ?? 0.0));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Total Spending Budget Card (Requirement: Separate Calculation)
        _SpendingBudgetCard(spent: totalSpent, budget: totalBudget),
        const SizedBox(height: 24),
        
        Text(
          'Quest Progress Summary',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        // Grid for Spending "Sub-Goals"
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.1,
          children: spendingCategories.map((category) {
            final spent = categoryTotals[category] ?? 0.0;
            final budget = userData.categoryBudgets[category.name] ?? 0.0;
            return _SummaryCard(
              category: category,
              spent: spent,
              budget: budget,
              isSubGoal: true, // Hides the "Goal" text per Prompt 10
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        // Separate Savings Card at the bottom
        _SummaryCard(
          category: savingsCategory,
          spent: categoryTotals[savingsCategory] ?? 0.0,
          budget: userData.categoryBudgets[savingsCategory.name] ?? 0.0,
          isSubGoal: false,
          isFullWidth: true,
        ),
      ],
    );
  }
}

class _SpendingBudgetCard extends StatelessWidget {
  final double spent;
  final double budget;

  const _SpendingBudgetCard({required this.spent, required this.budget});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final isOverBudget = budget > 0 && spent > budget;
    final progress = budget > 0 ? (spent / budget).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isOverBudget ? Colors.redAccent.withValues(alpha: 0.3) : primaryColor.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TOTAL SPENDING BUDGET',
                style: TextStyle(
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.white60,
                ),
              ),
              if (isOverBudget)
                const Text(
                  'LIMIT EXCEEDED',
                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 10),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '\$${spent.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: isOverBudget ? Colors.redAccent : Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'of \$${budget.toStringAsFixed(0)}',
                style: const TextStyle(color: Colors.white38, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.white.withValues(alpha: 0.05),
              valueColor: AlwaysStoppedAnimation<Color>(
                isOverBudget ? Colors.redAccent : primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final TransactionCategory category;
  final double spent;
  final double budget;
  final bool isSubGoal;
  final bool isFullWidth;

  const _SummaryCard({
    required this.category,
    required this.spent,
    required this.budget,
    this.isSubGoal = false,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    
    // Logic: Spending over budget is bad (Red). 
    // Savings going up is good (Primary Green).
    final isSpending = category != TransactionCategory.savings;
    final isOverBudget = budget > 0 && spent > budget;
    
    Color statusColor = Colors.white;
    if (isSpending) {
      if (isOverBudget) statusColor = Colors.redAccent;
    } else {
      // For savings, if we have saved anything, show it in a positive color
      if (spent > 0) statusColor = primaryColor;
    }

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: Card(
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
                  color: statusColor,
                ),
              ),
              // Only show the "Goal" text if it's NOT a sub-goal (Spending category) 
              // and we have a budget set.
              if (!isSubGoal && budget > 0)
                Text(
                  'Goal: \$${budget.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 12, color: Colors.white38),
                ),
            ],
          ),
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
