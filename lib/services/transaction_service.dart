import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart';

/// Pure logic class for [Cloud Firestore] transaction-related services.
class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Reference to the 'transactions' collection in Firestore.
  CollectionReference get _transactionsRef => _firestore.collection('transactions');

  /// Add a new transaction and reward the user with XP.
  Future<void> addTransaction(TransactionModel transaction) async {
    // 1. Add the transaction to Firestore
    _transactionsRef.add(transaction.toMap());

    // 2. Award XP (+5 per log as per requirements)
    final userDoc = _firestore.collection('users').doc(transaction.userId);
    await userDoc.update({
      'points': FieldValue.increment(5),
    });

    // 3. Brief delay for local cache propagation
    await Future.delayed(const Duration(milliseconds: 300));
  }

  /// Retrieve all transactions for a specific user as a [Stream].
  Stream<List<TransactionModel>> getTransactions(String userId) {
    return _transactionsRef
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => TransactionModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }
}
