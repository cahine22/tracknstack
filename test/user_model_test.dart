import 'package:flutter_test/flutter_test.dart';
import 'package:tracknstack/models/user_model.dart';

void main() {
  group('UserModel Leveling Logic', () {
    test('Level calculation follows Level = (sqrt(points) / 10).floor() + 1', () {
      expect(UserModel(uid: '1', email: '', displayName: '', points: 0).currentLevel, 1);
      expect(UserModel(uid: '1', email: '', displayName: '', points: 100).currentLevel, 2);
      expect(UserModel(uid: '1', email: '', displayName: '', points: 400).currentLevel, 3);
      expect(UserModel(uid: '1', email: '', displayName: '', points: 900).currentLevel, 4);
    });

    test('XP progress calculation is correct', () {
      // Level 1: 0 to 100 XP
      final user = UserModel(uid: '1', email: '', displayName: '', points: 50);
      expect(user.currentLevel, 1);
      expect(user.xpForCurrentLevel, 0);
      expect(user.xpForNextLevel, 100);
      expect(user.percentToNextLevel, 0.5);
    });
  });

  group('UserModel Savings Goal Logic', () {
    test('fromMap and toMap handle new savings goal fields', () {
      final data = {
        'email': 'hero@quest.com',
        'displayName': 'Hero',
        'points': 500,
        'savingsGoalName': 'New Shield',
        'savingsGoalTarget': 1000.0,
        'savingsGoalBase': 200.0,
        'completedGoalsCount': 1,
      };
      
      final user = UserModel.fromMap(data, 'uid123');
      
      expect(user.uid, 'uid123');
      expect(user.savingsGoalName, 'New Shield');
      expect(user.savingsGoalTarget, 1000.0);
      expect(user.savingsGoalBase, 200.0);
      expect(user.completedGoalsCount, 1);

      final mapped = user.toMap();
      expect(mapped['savingsGoalBase'], 200.0);
      expect(mapped['completedGoalsCount'], 1);
    });
  });
}
