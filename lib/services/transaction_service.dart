import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart';

/// Pure logic class for [Cloud Firestore] transaction-related services.
class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Reference to the 'transactions' collection in Firestore.
  CollectionReference get _transactionsRef => _firestore.collection('transactions');

  /// Add a new transaction.
  Future<void> addTransaction(TransactionModel transaction) async {
    // We do not await the server write to ensure the UI updates immediately 
    // using Firestore's offline persistence and to prevent infinite spinning 
    // if the network is slow or offline. 
    // However, we wait a brief moment to allow the local cache to propagate 
    // the new data through the stream and update the summary cards.
    _transactionsRef.add(transaction.toMap());
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
