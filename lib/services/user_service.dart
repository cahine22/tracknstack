import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

/// Pure logic class for [Cloud Firestore] user-related services.
/// 
/// Its only job is to interact with the 'users' collection 
/// in Firestore—saving profile info and retrieving it.
class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Reference to the 'users' collection in Firestore.
  CollectionReference get _usersRef => _firestore.collection('users');

  /// Create or update a user profile in Firestore.
  /// 
  /// [user] is the [UserModel] instance we want to save.
  Future<void> saveUser(UserModel user) async {
    // We use the User UID from Firebase Auth as the document ID 
    // to keep everything perfectly synced.
    await _usersRef.doc(user.uid).set(user.toMap(), SetOptions(merge: true));
  }

  /// Retrieve a user's data from Firestore as a [Stream].
  /// 
  /// This gives us real-time updates—if a user's points change, 
  /// the UI will update automatically.
  Stream<UserModel?> getUserData(String uid) {
    return _usersRef.doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return UserModel.fromMap(snapshot.data() as Map<String, dynamic>, snapshot.id);
      }
      return null;
    });
  }

  /// Award bonus XP to the user (e.g., for completing a savings goal).
  Future<void> awardBonusXP(String uid, int bonusXP) async {
    await _usersRef.doc(uid).update({
      'points': FieldValue.increment(bonusXP),
    });
  }

  /// Start a new savings goal by updating the target, name, and base.
  Future<void> startNewSavingsGoal(String uid, String newName, double newTarget, double currentTotalSavings) async {
    await _usersRef.doc(uid).update({
      'savingsGoalName': newName,
      'savingsGoalTarget': newTarget,
      'savingsGoalBase': currentTotalSavings,
      'completedGoalsCount': FieldValue.increment(1),
    });
  }
}
