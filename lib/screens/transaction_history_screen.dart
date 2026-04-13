import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';

/// A screen that displays a detailed, chronological log of transactions.
/// 
/// Users can view all transactions or filter by a specific category.
class TransactionHistoryScreen extends ConsumerWidget {
  final TransactionCategory? filterCategory;

  const TransactionHistoryScreen({super.key, this.filterCategory});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(filterCategory == null 
          ? 'Transaction History' 
          : '${filterCategory!.displayName} History'
        ),
      ),
      body: transactionsAsync.when(
        data: (transactions) {
          // Filter by category if requested
          final filteredList = filterCategory == null
              ? transactions
              : transactions.where((t) => t.category == filterCategory).toList();

          if (filteredList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_toggle_off, size: 64, color: Colors.white24),
                  const SizedBox(height: 16),
                  Text(
                    'No records found in this scroll.',
                    style: TextStyle(color: Colors.white38),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              final tx = filteredList[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: primaryColor.withValues(alpha: 0.1),
                    child: Icon(_getCategoryIcon(tx.category), color: primaryColor),
                  ),
                  title: Text(
                    '\$${tx.amount.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text(
                    tx.note ?? tx.category.displayName,
                    style: const TextStyle(color: Colors.white60),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat('MMM d, y').format(tx.date),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        DateFormat('jm').format(tx.date),
                        style: const TextStyle(fontSize: 10, color: Colors.white38),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading history: $err')),
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
