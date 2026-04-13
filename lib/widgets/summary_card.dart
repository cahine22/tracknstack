import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

class SummaryCard extends StatelessWidget {
  final TransactionCategory category;
  final double spent;
  final double budget;
  final bool isSubGoal;
  final bool isFullWidth;
  final VoidCallback? onTap;

  const SummaryCard({
    super.key,
    required this.category,
    required this.spent,
    required this.budget,
    this.isSubGoal = false,
    this.isFullWidth = false,
    this.onTap,
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
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
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
