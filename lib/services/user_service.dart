import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/savings_goal_model.dart';

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

  /// Add a new savings goal to the user's profile.
  Future<void> addSavingsGoal(String uid, SavingsGoalModel goal) async {
    final doc = await _usersRef.doc(uid).get();
    if (doc.exists && doc.data() != null) {
      final user = UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      final updatedGoals = List<SavingsGoalModel>.from(user.savingsGoals)..add(goal);
      await _usersRef.doc(uid).update({
        'savingsGoals': updatedGoals.map((g) => g.toMap()).toList(),
      });
    }
  }

  /// Complete a daily quest and award XP.
  Future<void> completeQuest(String uid, String questId, int xpReward) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final doc = await _usersRef.doc(uid).get();
    
    if (doc.exists && doc.data() != null) {
      final data = doc.data() as Map<String, dynamic>;
      final lastReset = data['lastQuestResetDate'] ?? '';
      List<String> completed = List<String>.from(data['completedQuests'] ?? []);

      // Reset if it's a new day
      if (lastReset != today) {
        completed = [questId];
      } else if (!completed.contains(questId)) {
        completed.add(questId);
      } else {
        return; // Already completed today
      }

      await _usersRef.doc(uid).update({
        'points': FieldValue.increment(xpReward),
        'completedQuests': completed,
        'lastQuestResetDate': today,
      });
    }
  }

  /// Start a new savings goal by updating the target, name, and base.
  Future<void> startNewSavingsGoal(String uid, String newName, double newTarget, double currentTotalSavings, {String? completedGoalId}) async {
    final newGoal = SavingsGoalModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: newName,
      target: newTarget,
      baseAmount: currentTotalSavings,
    );
    
    final doc = await _usersRef.doc(uid).get();
    if (doc.exists && doc.data() != null) {
      final user = UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      
      final updatedGoals = user.savingsGoals.map((g) {
        if (g.id == completedGoalId) {
          return SavingsGoalModel(
            id: g.id,
            name: g.name,
            target: g.target,
            baseAmount: g.baseAmount,
            isCompleted: true,
          );
        }
        return g;
      }).toList();
      
      updatedGoals.add(newGoal);
      
      await _usersRef.doc(uid).update({
        'savingsGoals': updatedGoals.map((g) => g.toMap()).toList(),
        'completedGoalsCount': FieldValue.increment(1),
        // Update legacy fields too just in case
        'savingsGoalName': newName,
        'savingsGoalTarget': newTarget,
        'savingsGoalBase': currentTotalSavings,
      });
    }
  }
}
