import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart';
import 'user_service.dart';

/// Pure logic class for [Cloud Firestore] transaction-related services.
class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService();

  /// Reference to the 'transactions' collection in Firestore.
  CollectionReference get _transactionsRef => _firestore.collection('transactions');

  /// Add a new transaction and reward the user with XP.
  Future<void> addTransaction(TransactionModel transaction) async {
    // 1. Add the transaction
    await _transactionsRef.add(transaction.toMap());
    
    // 2. Award standard transaction XP (+5 XP)
    final userDoc = _firestore.collection('users').doc(transaction.userId);
    await userDoc.update({
      'points': FieldValue.increment(5),
    });

    // 3. Trigger Daily Quest completion logic (+20 XP for the first log of the day)
    await _userService.completeQuest(transaction.userId, 'daily_log', 20);

    // 4. Brief delay for local cache propagation
    await Future.delayed(const Duration(milliseconds: 300));
  }

  /// Retrieve all transactions for a specific user as a [Stream].
  Stream<List<TransactionModel>> getTransactions(String userId) {
    // We remove the orderBy('date') to avoid requiring a composite index.
    // Instead, we sort the transactions in memory on the client side.
    return _transactionsRef
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final transactions = snapshot.docs
          .map((doc) => TransactionModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      
      // Client-side sorting: newest first.
      transactions.sort((a, b) => b.date.compareTo(a.date));
      
      return transactions;
    });
  }
}
