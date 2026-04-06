import 'package:flutter/material.dart';

class SpendingBudgetCard extends StatelessWidget {
  final double spent;
  final double budget;

  const SpendingBudgetCard({super.key, required this.spent, required this.budget});

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
