import 'savings_goal_model.dart';

/// A data model for our user profile in Firestore.
/// 
/// Following our 'Clean Code' principles, this class separates 
/// how our data looks from how it's used in the UI.
class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final int points;
  final double monthlyBudget;
  final Map<String, double> categoryBudgets;
  final double savingsGoalTarget; // Legacy: Keeping for backward compatibility
  final String savingsGoalName; // Legacy: Keeping for backward compatibility
  final double savingsGoalBase; // Legacy: Keeping for backward compatibility
  final int completedGoalsCount;
  final List<SavingsGoalModel> savingsGoals;
  final String lastQuestResetDate; // YYYY-MM-DD
  final List<String> completedQuests;
  final List<String> activeWeeklyChallenges; // IDs of the 2 challenges for the week
  final List<String> acceptedWeeklyChallenges; // IDs of challenges the user opted into
  final List<String> completedWeeklyChallenges; // IDs of challenges completed this week
  final String lastWeeklyResetDate; // YYYY-MM-DD (typically a Monday)
  final int streakCount;
  final String lastLogDate; // YYYY-MM-DD

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.points = 0,
    this.monthlyBudget = 0.0,
    this.categoryBudgets = const {
      'needs': 0.0,
      'wants': 0.0,
      'savings': 0.0,
      'others': 0.0,
    },
    this.savingsGoalTarget = 0.0,
    this.savingsGoalName = 'Main Quest',
    this.savingsGoalBase = 0.0,
    this.completedGoalsCount = 0,
    this.savingsGoals = const [],
    this.lastQuestResetDate = '',
    this.completedQuests = const [],
    this.activeWeeklyChallenges = const [],
    this.acceptedWeeklyChallenges = const [],
    this.completedWeeklyChallenges = const [],
    this.lastWeeklyResetDate = '',
    this.streakCount = 0,
    this.lastLogDate = '',
  });

  /// Factory constructor to create a [UserModel] from a Map.
  /// Used when retrieving data from Firestore.
  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    List<SavingsGoalModel> goals = (data['savingsGoals'] as List<dynamic>?)
        ?.map((g) {
          final goalData = g as Map<String, dynamic>;
          return SavingsGoalModel.fromMap(goalData, goalData['id'] ?? '');
        })
        .toList() ?? [];

    // Legacy Migration: If there are no goals but there are legacy goal fields, add them.
    if (goals.isEmpty && (data['savingsGoalTarget'] ?? 0) > 0) {
      goals.add(SavingsGoalModel(
        id: 'legacy-primary',
        name: data['savingsGoalName'] ?? 'Main Quest',
        target: (data['savingsGoalTarget'] ?? 0.0).toDouble(),
        baseAmount: (data['savingsGoalBase'] ?? 0.0).toDouble(),
      ));
    }

    return UserModel(
      uid: documentId,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? 'User',
      photoUrl: data['photoUrl'],
      points: data['points'] ?? 0,
      monthlyBudget: (data['monthlyBudget'] ?? 0.0).toDouble(),
      categoryBudgets: (data['categoryBudgets'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, (value as num).toDouble()),
      ) ?? const {
        'needs': 0.0,
        'wants': 0.0,
        'savings': 0.0,
        'others': 0.0,
      },
      savingsGoalTarget: (data['savingsGoalTarget'] ?? 0.0).toDouble(),
      savingsGoalName: data['savingsGoalName'] ?? 'Main Quest',
      savingsGoalBase: (data['savingsGoalBase'] ?? 0.0).toDouble(),
      completedGoalsCount: data['completedGoalsCount'] ?? 0,
      savingsGoals: goals,
      lastQuestResetDate: data['lastQuestResetDate'] ?? '',
      completedQuests: List<String>.from(data['completedQuests'] ?? []),
      activeWeeklyChallenges: List<String>.from(data['activeWeeklyChallenges'] ?? []),
      acceptedWeeklyChallenges: List<String>.from(data['acceptedWeeklyChallenges'] ?? []),
      completedWeeklyChallenges: List<String>.from(data['completedWeeklyChallenges'] ?? []),
      lastWeeklyResetDate: data['lastWeeklyResetDate'] ?? '',
      streakCount: data['streakCount'] ?? 0,
      lastLogDate: data['lastLogDate'] ?? '',
    );
  }

  /// Converts the [UserModel] instance into a Map.
  /// Used when saving data to Firestore.
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'points': points,
      'monthlyBudget': monthlyBudget,
      'categoryBudgets': categoryBudgets,
      'savingsGoalTarget': savingsGoalTarget,
      'savingsGoalName': savingsGoalName,
      'savingsGoalBase': savingsGoalBase,
      'completedGoalsCount': completedGoalsCount,
      'savingsGoals': savingsGoals.map((g) => g.toMap()).toList(),
      'lastQuestResetDate': lastQuestResetDate,
      'completedQuests': completedQuests,
      'activeWeeklyChallenges': activeWeeklyChallenges,
      'acceptedWeeklyChallenges': acceptedWeeklyChallenges,
      'completedWeeklyChallenges': completedWeeklyChallenges,
      'lastWeeklyResetDate': lastWeeklyResetDate,
      'streakCount': streakCount,
      'lastLogDate': lastLogDate,
    };
  }

  /// Leveling Logic: Level = (sqrt(points) / 10).floor() + 1
  int get currentLevel => (Math.sqrt(points) / 10).floor() + 1;

  /// XP required for the NEXT level
  int get xpForNextLevel => Math.pow((currentLevel) * 10, 2).toInt();

  /// XP required for the CURRENT level
  int get xpForCurrentLevel => Math.pow((currentLevel - 1) * 10, 2).toInt();

  /// Progress (0.0 to 1.0) towards the next level
  double get percentToNextLevel {
    final range = xpForNextLevel - xpForCurrentLevel;
    final progress = points - xpForCurrentLevel;
    if (range == 0) return 0.0;
    return (progress / range).clamp(0.0, 1.0);
  }
}

/// Simple Math polyfill for level calculations
class Math {
  static double sqrt(num n) => _sqrt(n.toDouble());
  static double _sqrt(double n) {
    if (n < 0) return double.nan;
    if (n == 0) return 0;
    double x = n;
    double y = 1;
    double e = 0.000001;
    while (x - y > e) {
      x = (x + y) / 2;
      y = n / x;
    }
    return x;
  }

  static num pow(num base, num exponent) {
    num result = 1;
    for (int i = 0; i < exponent; i++) {
      result *= base;
    }
    return result;
  }
}
