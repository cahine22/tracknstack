import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart';

/// Pure logic class for [Cloud Firestore] transaction-related services.
class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Reference to the 'transactions' collection in Firestore.
  CollectionReference get _transactionsRef => _firestore.collection('transactions');

  /// Add a new transaction.
  Future<void> addTransaction(TransactionModel transaction) async {
    // We do not await this write to ensure the UI updates immediately 
    // using Firestore's offline persistence. Awaiting would cause 
    // the 'loading' icon to spin forever if the network is slow or 
    // the server hasn't acknowledged yet.
    _transactionsRef.add(transaction.toMap());
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
