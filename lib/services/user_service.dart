import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' as math;
import '../models/user_model.dart';
import '../models/savings_goal_model.dart';
import '../models/challenge_model.dart';

/// Pure logic class for [Cloud Firestore] user-related services.
class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Reference to the 'users' collection in Firestore.
  CollectionReference get _usersRef => _firestore.collection('users');

  /// Create or update a user profile in Firestore.
  Future<void> saveUser(UserModel user) async {
    await _usersRef.doc(user.uid).set(user.toMap(), SetOptions(merge: true));
  }

  /// Retrieve a user's data from Firestore as a [Stream].
  Stream<UserModel?> getUserData(String uid) {
    return _usersRef.doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return UserModel.fromMap(snapshot.data() as Map<String, dynamic>, snapshot.id);
      }
      return null;
    });
  }

  /// Award bonus XP to the user.
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

  /// Refresh weekly challenges if it's a new week.
  Future<void> refreshWeeklyChallenges(String uid) async {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final mondayStr = monday.toIso8601String().split('T')[0];

    final doc = await _usersRef.doc(uid).get();
    if (doc.exists && doc.data() != null) {
      final data = doc.data() as Map<String, dynamic>;
      final lastReset = data['lastWeeklyResetDate'] ?? '';

      if (lastReset != mondayStr) {
        final random = math.Random();
        final pool = List<ChallengeModel>.from(ChallengeModel.pool);
        pool.shuffle(random);
        final selectedIds = pool.take(2).map((c) => c.id).toList();

        await _usersRef.doc(uid).update({
          'activeWeeklyChallenges': selectedIds,
          'acceptedWeeklyChallenges': [],
          'completedWeeklyChallenges': [],
          'lastWeeklyResetDate': mondayStr,
        });
      }
    }
  }

  /// Opt into a weekly challenge.
  Future<void> acceptChallenge(String uid, String challengeId) async {
    await _usersRef.doc(uid).update({
      'acceptedWeeklyChallenges': FieldValue.arrayUnion([challengeId]),
    });
  }

  /// Complete a weekly challenge and award XP.
  Future<void> completeWeeklyChallenge(String uid, String challengeId, int xpReward) async {
    await _usersRef.doc(uid).update({
      'points': FieldValue.increment(xpReward),
      'completedWeeklyChallenges': FieldValue.arrayUnion([challengeId]),
    });
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
        'savingsGoalName': newName,
        'savingsGoalTarget': newTarget,
        'savingsGoalBase': currentTotalSavings,
      });
    }
  }
}
