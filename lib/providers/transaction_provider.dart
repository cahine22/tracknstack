import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction_model.dart';
import '../services/transaction_service.dart';
import 'auth_provider.dart';

/// Provider for the [TransactionService] singleton.
final transactionServiceProvider = Provider<TransactionService>((ref) => TransactionService());

/// A [StreamProvider] that supplies the list of transactions for the current user.
final transactionsProvider = StreamProvider<List<TransactionModel>>((ref) {
  final authUser = ref.watch(authStateProvider).value;
  final transactionService = ref.watch(transactionServiceProvider);

  if (authUser == null) return Stream.value([]);

  return transactionService.getTransactions(authUser.uid);
});

/// A [Provider] that calculates total savings from transactions.
final totalSavingsProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionsProvider).value ?? [];
  return transactions
      .where((t) => t.category == TransactionCategory.savings)
      .fold(0.0, (sum, t) => sum + t.amount);
});

/// A [Provider] that calculates totals per category.
final categoryTotalsProvider = Provider<Map<TransactionCategory, double>>((ref) {
  final transactions = ref.watch(transactionsProvider).value ?? [];
  final totals = {
    TransactionCategory.needs: 0.0,
    TransactionCategory.wants: 0.0,
    TransactionCategory.savings: 0.0,
    TransactionCategory.others: 0.0,
  };

  for (final t in transactions) {
    totals[t.category] = (totals[t.category] ?? 0.0) + t.amount;
  }
  return totals;
});

/// A [Provider] that calculates total savings per goal ID.
final savingsByGoalProvider = Provider<Map<String, double>>((ref) {
  final transactions = ref.watch(transactionsProvider).value ?? [];
  final map = <String, double>{};

  for (final t in transactions) {
    if (t.category == TransactionCategory.savings && t.savingsGoalId != null) {
      map[t.savingsGoalId!] = (map[t.savingsGoalId!] ?? 0.0) + t.amount;
    }
  }
  return map;
});
